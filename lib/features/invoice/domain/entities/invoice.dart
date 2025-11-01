import 'package:json_annotation/json_annotation.dart';
import 'bill_item.dart';

enum BillStatus {
  @JsonValue('UNPAID')
  unpaid,
  @JsonValue('PAID')
  paid,
  @JsonValue('OVERDUE')
  overdue,
  @JsonValue('CANCELLED')
  cancelled,
  @JsonValue('PARTIALLY_PAID')
  partiallyPaid,
}

class Invoice {
  final String id;
  final String? contractId;
  final String? roomId;
  final String? tenantId;
  final String? billNumber;
  final BillStatus status;
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final DateTime? dueDate;
  final double totalAmount;
  final double lateFee;
  final double discountAmount;
  final String? billType;
  final String? notes;
  final String? roomCode;
  final String? roomName;
  final String? tenantName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<BillItem> items;

  const Invoice({
    required this.id,
    this.contractId,
    this.roomId,
    this.tenantId,
    this.billNumber,
    required this.status,
    this.periodStart,
    this.periodEnd,
    this.dueDate,
    required this.totalAmount,
    required this.lateFee,
    required this.discountAmount,
    this.billType,
    this.notes,
    this.roomCode,
    this.roomName,
    this.tenantName,
    required this.createdAt,
    required this.updatedAt,
    this.items = const [],
  });

  // Helper methods
  bool get isOverdue {
    if (dueDate == null) return false;
    return status == BillStatus.unpaid && DateTime.now().isAfter(dueDate!);
  }

  double get finalAmount => totalAmount + lateFee - discountAmount;

  String get statusText {
    switch (status) {
      case BillStatus.unpaid:
        return isOverdue ? 'Quá hạn' : 'Chưa thanh toán';
      case BillStatus.paid:
        return 'Đã thanh toán';
      case BillStatus.overdue:
        return 'Quá hạn';
      case BillStatus.cancelled:
        return 'Đã hủy';
      case BillStatus.partiallyPaid:
        return 'Thanh toán một phần';
    }
  }
}
