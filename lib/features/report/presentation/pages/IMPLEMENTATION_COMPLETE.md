# ✅ ĐÃ HOÀN THÀNH: Tab "Công việc bảo trì"

## 🎯 Thay đổi

Đã thêm **Tab thứ 2** vào `ReportPage` để hiển thị maintenance records.

### 📱 UI Structure

```
ReportPage (với DefaultTabController)
├── TabBar
│   ├── Tab 1: "Báo cáo sự cố" (Maintenance Requests)
│   └── Tab 2: "Công việc bảo trì" (Maintenance Records) ← MỚI
└── TabBarView
    ├── _MaintenanceRequestsTab (existing logic)
    └── _MaintenanceRecordsTab (NEW - hiển thị maintenance)
```

### 🎨 Features

**Tab "Công việc bảo trì" hiển thị:**

1. ✅ **Status Badge** với màu sắc:
   - 🟠 PENDING - "Chờ xử lý" (Màu cam)
   - 🔵 IN_PROGRESS - "Đang xử lý" (Màu xanh)
   - 🟢 COMPLETED - "Hoàn thành" (Màu xanh lá)

2. ✅ **Badge "Từ báo cáo của bạn"**:
   - Hiển thị nếu `maintenance.maintenanceRequestId != null`
   - Màu xanh dương với icon person
   - Cho biết maintenance này được tạo từ request của tenant

3. ✅ **Thông tin chi tiết**:
   - Title & Description
   - Property & Room
   - Maintenance Type & Priority
   - Cost (nếu có)
   - Timestamps (Created & Updated)

4. ✅ **Read-only Notice**:
   - Container màu xám
   - Icon visibility
   - Text: "Chỉ xem - Bạn không thể chỉnh sửa công việc bảo trì"

### 🧪 Cách Test

#### **Bước 1: Restart App**
```bash
# Stop app và chạy lại
flutter run
```

#### **Bước 2: Navigate to Report Page**
- Mở app
- Vào trang "Báo cáo" (Report)

#### **Bước 3: Kiểm tra TabBar**
Bạn sẽ thấy 2 tabs:
```
[Báo cáo sự cố]  [Công việc bảo trì]
```

#### **Bước 4: Tap vào Tab "Công việc bảo trì"**
Sẽ hiển thị **4 maintenance records**:

1. ✅ **"Yêu cầu từ tenant: xvsdvsdfdf"**
   - Status: 🔵 Đang xử lý
   - Badge: 👤 Từ báo cáo của bạn
   - Property: NHA TRO ABC
   - Room: P1

2. ✅ **"test"**
   - Status: 🔵 Đang xử lý
   - Property: NHA TRO ABC

3. ✅ **"sdfwsf"**
   - Status: 🟠 Chờ xử lý
   - Property: NHA TRO ABC

4. ✅ **"vỡ sân"**
   - Status: 🟠 Chờ xử lý
   - Property: NHA TRO ABC

### 📊 Data Flow

```
User taps Tab 2
    ↓
ref.watch(maintenanceRecordsProvider)
    ↓
MaintenanceRequestRepository.getMaintenanceRecords()
    ↓
MaintenanceRequestRemoteDatasource.getMaintenanceRecords()
    ↓
Supabase Query:
  1. Get active contracts
  2. Extract property_ids
  3. Query maintenance WHERE:
     - property_id IN (contracts)
     - status != 'CANCELLED'  ← Ẩn CANCELLED
     - deleted_at IS NULL
    ↓
Return List<MaintenanceModel>
    ↓
Convert to List<Maintenance> entities
    ↓
Display in _MaintenanceCard widgets
```

### 🔐 Security & Business Logic

✅ **Tenant chỉ thấy maintenance của properties đang thuê**
- Filter qua active contracts

✅ **Ẩn CANCELLED status**
- Theo MAINTENANCE_LOGIC.md: Tenant không được thấy maintenance bị hủy

✅ **Read-only**
- Không có button edit/delete
- Chỉ hiển thị thông tin

✅ **Link to Request**
- Badge hiển thị nếu maintenance được tạo từ request của tenant
- `maintenanceRequestId != null`

### 🎭 Expected Result

**Khi admin APPROVE request của bạn:**

**Tab 1 - Báo cáo sự cố:**
```
📋 "xvsdvsdfdf"
✅ Status: Đã duyệt (APPROVED)
```

**Tab 2 - Công việc bảo trì:**
```
🔧 "Yêu cầu từ tenant: xvsdvsdfdf"
🔵 Status: Đang xử lý (IN_PROGRESS)
👤 Badge: Từ báo cáo của bạn
```

➡️ **Bạn sẽ thấy CÙNG một issue ở CẢ 2 TAB**:
- Tab 1: Request (status APPROVED)
- Tab 2: Maintenance (status IN_PROGRESS)

### 🐛 Troubleshooting

**Nếu Tab 2 trống:**
1. Kiểm tra console logs:
   ```
   🏢 [DEBUG] Fetching maintenance for properties: [...]
   ✅ [DEBUG] Found X maintenance records
   ```

2. Verify tenant có active contract:
   ```dart
   final contracts = await ref.read(activeContractsProvider.future);
   print('Contracts: ${contracts.length}');
   ```

3. Check Supabase data:
   - Vào Supabase Table Editor
   - Xem bảng `maintenance`
   - Filter: `status != 'CANCELLED' AND deleted_at IS NULL`

**Nếu có lỗi:**
- Red error text sẽ hiển thị trong tab
- Check console để xem error details

### 📝 Files Changed

1. ✅ `/lib/features/report/presentation/pages/report_page.dart`
   - Thêm `DefaultTabController`
   - Thêm `TabBar` với 2 tabs
   - Thêm `_MaintenanceRecordsTab` widget
   - Thêm `_MaintenanceList` widget
   - Thêm `_MaintenanceCard` widget
   - Thêm `_EmptyMaintenanceState` widget

### 🚀 Next Steps (Optional)

**Enhancement ideas:**
1. Thêm pull-to-refresh cho cả 2 tabs
2. Thêm search/filter trong maintenance list
3. Navigate từ Tab 2 về Tab 1 khi tap vào request badge
4. Realtime updates cho maintenance status changes
5. Notification khi maintenance status change

---

## ✅ Status: READY TO TEST

Khởi động lại app và test ngay! 🎉
