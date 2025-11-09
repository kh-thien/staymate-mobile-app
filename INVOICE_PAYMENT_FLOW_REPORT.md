# Báo Cáo Chi Tiết: Flow Thanh Toán Chuyển Khoản Ngân Hàng

## Tổng Quan

Khi người dùng bấm "Xác nhận đã thanh toán" trong trang chuyển khoản ngân hàng (`bank_transfer_page.dart`), hệ thống thực hiện các bước sau:

---

## 1. Hành Động Khi Bấm "Xác Nhận Đã Thanh Toán"

### Code Location
- **File**: `lib/features/invoice/presentation/pages/bank_transfer_page.dart`
- **Lines**: 375-398

### Flow Thực Hiện

```dart
// Step 1: Update bill status to PROCESSING
await ref.read(invoiceRepositoryProvider).updateBillStatus(
  invoice.billNumber ?? invoice.id,
  BillStatus.processing,
);

// Step 2: Update payment method and date in payments table
await ref.read(invoiceRepositoryProvider).updatePaymentInfo(
  billId: invoice.id,
  paymentMethod: PaymentMethod.bankTransfer,
  paymentDate: DateTime.now().toUtc(),
);
```

---

## 2. Các Bảng Được Cập Nhật

### 2.1. Bảng `bills`

**Các trường được cập nhật:**
- `status` → `'PROCESSING'`
- `updated_at` → `NOW()` (tự động bởi trigger)

**Code Location:**
- **File**: `lib/features/invoice/data/datasources/invoice_remote_datasource.dart`
- **Function**: `updateBillStatus()`
- **Lines**: 367-411

**SQL Query:**
```sql
UPDATE bills
SET status = 'PROCESSING'
WHERE id = :billId OR bill_number = :billNumber
```

### 2.2. Bảng `payments`

**Các trường được cập nhật:**
- `method` → `'BANK_TRANSFER'`
- `payment_date` → `DateTime.now().toUtc()`
- `updated_at` → `NOW()` (tự động bởi trigger)

**Code Location:**
- **File**: `lib/features/invoice/data/datasources/invoice_remote_datasource.dart`
- **Function**: `updatePaymentInfo()`
- **Lines**: 413-446

**SQL Query:**
```sql
UPDATE payments
SET 
  method = 'BANK_TRANSFER',
  payment_date = :paymentDate
WHERE bill_id = :billId
```

---

## 3. Các Trigger Được Kích Hoạt

### 3.1. Khi Update `bills.status = 'PROCESSING'`

#### 3.1.1. Trigger: `trigger_update_bill_overdue_status` (BEFORE UPDATE)
- **Function**: `update_bill_overdue_status()`
- **Timing**: BEFORE
- **Hành động**:
  - Kiểm tra nếu `status = 'UNPAID'` và `due_date < CURRENT_DATE` → tự động chuyển thành `'OVERDUE'`
  - Nếu `status = 'PAID'` hoặc `'CANCELLED'` → giữ nguyên
- **Kết quả**: Không ảnh hưởng vì status đang là `'PROCESSING'`

#### 3.1.2. Trigger: `trigger_update_payment_on_bill_processing` (AFTER UPDATE OF status)
- **Function**: `update_payment_on_bill_processing()`
- **Timing**: AFTER UPDATE OF status
- **Hành động**:
  ```sql
  IF NEW.status = 'PROCESSING' THEN
    UPDATE payments
    SET payment_status = 'PENDING_APPROVE'
    WHERE bill_id = NEW.id;
  END IF;
  ```
- **Kết quả**: 
  - Tự động update `payments.payment_status = 'PENDING_APPROVE'` cho tất cả payments của bill này
  - Đây là trạng thái chờ chủ nhà xác nhận đã nhận tiền
  - **Lưu ý**: Trigger này chỉ chạy khi cột `status` được update (hiệu quả hơn)

#### 3.1.3. Trigger: `update_payment_status_trigger` (AFTER UPDATE)
- **Function**: `update_payment_status_on_bill_status_change()`
- **Timing**: AFTER
- **Hành động**:
  ```sql
  IF OLD.status != NEW.status THEN
    IF NEW.status = 'UNPAID' THEN
      UPDATE payments SET payment_status = 'PENDING' WHERE bill_id = NEW.id;
    ELSIF NEW.status = 'PAID' THEN
      UPDATE payments SET payment_status = 'COMPLETED' WHERE bill_id = NEW.id;
    END IF;
  END IF;
  ```
- **Kết quả**: Không ảnh hưởng vì status là `'PROCESSING'` (không có case xử lý)

#### 3.1.4. Trigger: `audit_bills_trigger` (AFTER UPDATE)
- **Function**: `audit_trigger_function()`
- **Timing**: AFTER
- **Hành động**: Ghi log audit vào bảng `audit_logs`

---

### 3.2. Khi Update `payments`

#### 3.2.1. Trigger: `update_bill_status_trigger` (AFTER UPDATE)
- **Function**: `update_bill_status()`
- **Timing**: AFTER
- **Hành động**:
  ```sql
  -- Kiểm tra nếu bill đang PROCESSING thì không update status
  IF current_status = 'PROCESSING' THEN
    RETURN NEW;
  END IF;
  
  -- Tính tổng số tiền đã thanh toán (CHỈ TÍNH COMPLETED payments)
  SELECT COALESCE(SUM(amount), 0) INTO total_paid
  FROM payments 
  WHERE bill_id = NEW.bill_id
    AND deleted_at IS NULL
    AND payment_status = 'COMPLETED';
  
  -- Cập nhật status của bill
  UPDATE bills 
  SET status = CASE 
    WHEN total_paid >= bill_total THEN 'PAID'
    WHEN total_paid > 0 THEN 'PARTIALLY_PAID'
    ELSE 'UNPAID'
  END
  WHERE id = NEW.bill_id;
  ```
- **Kết quả**: 
  - **KHÔNG** update bill status vì bill đang ở trạng thái `'PROCESSING'`
  - Trigger sẽ return sớm và không làm gì

#### 3.2.2. Trigger: `trigger_update_bill_on_payment_completed` (AFTER UPDATE)
- **Function**: `update_bill_status_on_payment_completed()`
- **Timing**: AFTER
- **Hành động**:
  ```sql
  IF NEW.payment_status = 'COMPLETED' AND 
     (OLD.payment_status IS NULL OR OLD.payment_status != 'COMPLETED') THEN
    UPDATE bills
    SET status = 'PAID',
        updated_at = NOW()
    WHERE id = NEW.bill_id;
  END IF;
  ```
- **Kết quả**: 
  - Không ảnh hưởng vì `payment_status` không được set thành `'COMPLETED'` trong lần update này
  - `payment_status` được set thành `'PENDING_APPROVE'` bởi trigger trên `bills`

#### 3.2.3. Trigger: `audit_payments_trigger` (AFTER UPDATE)
- **Function**: `audit_trigger_function()`
- **Timing**: AFTER
- **Hành động**: Ghi log audit vào bảng `audit_logs`

---

## 4. RLS Policies

### 4.1. RLS trên Bảng `bills`

#### Update Policy: "Tenants can update their bills status"
- **Condition**: 
  ```sql
  tenant_id IN (
    SELECT tenants.id 
    FROM tenants 
    WHERE tenants.user_id = auth.uid()
  )
  AND status IN ('UNPAID', 'PROCESSING', 'OVERDUE')
  ```
- **With Check**: 
  ```sql
  status IN ('UNPAID', 'PROCESSING', 'PAID', 'OVERDUE', 'CANCELLED', 'PARTIALLY_PAID')
  ```
- **Kết quả**: Tenant có thể update bill status từ `'UNPAID'` → `'PROCESSING'` ✅

### 4.2. RLS trên Bảng `payments`

#### Update Policy: "Tenant user can update their payments"
- **Condition**: 
  ```sql
  EXISTS (
    SELECT 1
    FROM bills
    JOIN tenants ON bills.tenant_id = tenants.id
    WHERE bills.id = payments.bill_id
      AND tenants.user_id = auth.uid()
  )
  ```
- **Kết quả**: Tenant có thể update payment info của bill của mình ✅

---

## 5. Flow Hoàn Chỉnh

```
1. User bấm "Xác nhận đã thanh toán"
   ↓
2. Update bills.status = 'PROCESSING'
   ↓
3. Trigger: trigger_update_payment_on_bill_processing() (AFTER UPDATE OF status)
   → Update payments.payment_status = 'PENDING_APPROVE'
   ↓
4. Update payments.method = 'BANK_TRANSFER'
   Update payments.payment_date = NOW()
   ↓
5. Trigger: update_bill_status()
   → Return early (bill đang PROCESSING)
   ↓
6. Kết quả:
   - bills.status = 'PROCESSING'
   - payments.method = 'BANK_TRANSFER'
   - payments.payment_date = [current time UTC]
   - payments.payment_status = 'PENDING_APPROVE'
   
Lưu ý: Trigger duplicate đã được xóa, chỉ còn một trigger chạy khi status thay đổi.
```

---

## 6. Các Trạng Thái Có Thể

### Bill Status:
- `UNPAID` → `PROCESSING` (khi tenant xác nhận đã chuyển khoản)
- `PROCESSING` → `PAID` (khi landlord xác nhận đã nhận tiền)
- `PROCESSING` → `UNPAID` (nếu landlord từ chối)

### Payment Status:
- `PENDING` → `PENDING_APPROVE` (khi bill chuyển sang PROCESSING)
- `PENDING_APPROVE` → `COMPLETED` (khi landlord xác nhận)
- `PENDING_APPROVE` → `PENDING` (nếu landlord từ chối)

---

## 7. Vấn Đề Tiềm Ẩn

### 7.1. Race Condition
- Có 2 triggers update `payments.payment_status`:
  - `update_payment_on_bill_processing()` set `PENDING_APPROVE`
  - `update_payment_status_on_bill_status_change()` không xử lý `PROCESSING`
- **Kết quả**: Không có conflict, trigger đầu tiên sẽ set `PENDING_APPROVE`

### 7.2. Duplicate Triggers
- ~~Có 2 triggers cùng function `update_payment_on_bill_processing()`:~~
  - ~~`trg_update_payment_on_bill_processing`~~ ✅ **ĐÃ XÓA**
  - `trigger_update_payment_on_bill_processing` ✅ **GIỮ LẠI**
- **Đã xử lý**: Đã xóa trigger `trg_update_payment_on_bill_processing` (generic), giữ lại `trigger_update_payment_on_bill_processing` (specific, chỉ trigger khi status thay đổi)

### 7.3. Payment Status Không Đồng Bộ
- Khi update `payments.method` và `payments.payment_date`, `payment_status` vẫn có thể là `NULL` hoặc `PENDING`
- **Giải pháp**: Trigger `update_payment_on_bill_processing()` sẽ set `PENDING_APPROVE` sau khi update bill status

---

## 8. Khuyến Nghị

1. ~~**Xóa duplicate trigger**: Xóa một trong hai triggers `update_payment_on_bill_processing()`~~ ✅ **ĐÃ HOÀN THÀNH**
2. **Thêm validation**: Đảm bảo `payment_status` được set đúng khi update payment info
3. **Thêm logging**: Log chi tiết các bước trong flow để dễ debug
4. **Thêm transaction**: Đảm bảo atomicity khi update cả `bills` và `payments`

---

## 9. Test Cases

### Test Case 1: Tenant xác nhận đã chuyển khoản
- **Input**: Bill status = `UNPAID`
- **Action**: Update bill status = `PROCESSING`, update payment method = `BANK_TRANSFER`
- **Expected**:
  - `bills.status` = `PROCESSING`
  - `payments.method` = `BANK_TRANSFER`
  - `payments.payment_date` = current time
  - `payments.payment_status` = `PENDING_APPROVE`

### Test Case 2: Landlord xác nhận đã nhận tiền
- **Input**: Bill status = `PROCESSING`, payment status = `PENDING_APPROVE`
- **Action**: Update payment status = `COMPLETED`
- **Expected**:
  - `payments.payment_status` = `COMPLETED`
  - `bills.status` = `PAID` (bởi trigger `update_bill_status_on_payment_completed()`)

---

## 10. Kết Luận

Flow thanh toán chuyển khoản ngân hàng hoạt động đúng với các trigger và RLS policies hiện tại. Tuy nhiên, cần:
1. Xóa duplicate triggers
2. Thêm validation và error handling
3. Thêm logging chi tiết
4. Test kỹ các edge cases

