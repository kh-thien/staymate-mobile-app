import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../core/localization/app_localizations_helper.dart';
import 'bill_item.dart';

enum BillStatus {
  @JsonValue('UNPAID')
  unpaid,
  @JsonValue('PROCESSING')
  processing,
  @JsonValue('PAID')
  paid,
  @JsonValue('OVERDUE')
  overdue,
  @JsonValue('CANCELLED')
  cancelled,
  @JsonValue('PARTIALLY_PAID')
  partiallyPaid,
}

extension BillStatusExtension on BillStatus {
  String toJsonValue() {
    switch (this) {
      case BillStatus.unpaid:
        return 'UNPAID';
      case BillStatus.processing:
        return 'PROCESSING';
      case BillStatus.paid:
        return 'PAID';
      case BillStatus.overdue:
        return 'OVERDUE';
      case BillStatus.cancelled:
        return 'CANCELLED';
      case BillStatus.partiallyPaid:
        return 'PARTIALLY_PAID';
    }
  }
}

enum PaymentMethod {
  @JsonValue('BANK_TRANSFER')
  bankTransfer,
  @JsonValue('QRCODE')
  qrCode,
  @JsonValue('MOMO')
  momo,
  @JsonValue('ZALO_PAY')
  zaloPay,
  @JsonValue('CARD')
  card,
}

class Invoice {
  final String id;
  final String? contractId;
  final String? roomId;
  final String? tenantId;
  final String? billNumber;
  final String? name;
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
    this.name,
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

  // total_amount trong DB đã là số tiền cuối cùng (đã cộng late_fee và trừ discount_amount)
  // late_fee và discount_amount chỉ để hiển thị thông tin, không dùng để tính toán
  double get finalAmount => totalAmount;

  // Tổng tiền từ các bill items (tổng tiền gốc trước khi giảm và cộng phí)
  double get itemsTotalAmount {
    return items.fold<double>(0.0, (sum, item) => sum + (item.amount));
  }

  String get statusText {
    switch (status) {
      case BillStatus.unpaid:
        return isOverdue ? 'Quá hạn' : 'Chưa thanh toán';
      case BillStatus.processing:
        return 'Chờ duyệt';
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

// Helper extension for PaymentMethod
extension PaymentMethodExtension on PaymentMethod {
  String displayName(String languageCode) {
    final key = switch (this) {
      PaymentMethod.bankTransfer => 'paymentMethodBankTransfer',
      PaymentMethod.qrCode => 'paymentMethodQrCode',
      PaymentMethod.momo => 'paymentMethodMomo',
      PaymentMethod.zaloPay => 'paymentMethodZaloPay',
      PaymentMethod.card => 'paymentMethodCard',
    };

    return AppLocalizationsHelper.translate(key, languageCode);
  }

  IconData get icon {
    switch (this) {
      case PaymentMethod.bankTransfer:
        return Icons.account_balance;
      case PaymentMethod.qrCode:
        return Icons.qr_code_2;
      case PaymentMethod.momo:
        return Icons.account_balance_wallet;
      case PaymentMethod.zaloPay:
        return Icons.payment;
      case PaymentMethod.card:
        return Icons.credit_card;
    }
  }

  bool get isAvailable {
    switch (this) {
      case PaymentMethod.bankTransfer:
      case PaymentMethod.qrCode:
        return true;
      case PaymentMethod.momo:
      case PaymentMethod.zaloPay:
      case PaymentMethod.card:
        return false; // Chưa phát triển
    }
  }

  String? comingSoonText(String languageCode) {
    if (isAvailable) return null;
    return AppLocalizationsHelper.translate(
      'paymentMethodComingSoon',
      languageCode,
    );
  }
}
