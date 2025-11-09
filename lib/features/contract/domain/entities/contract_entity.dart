import 'package:json_annotation/json_annotation.dart';

enum TerminationReason {
  @JsonValue('EXPIRED')
  expired,
  @JsonValue('VIOLATION')
  violation,
  @JsonValue('TENANT_REQUEST')
  tenantRequest,
  @JsonValue('LANDLORD_REQUEST')
  landlordRequest,
  @JsonValue('OTHER')
  other,
}

extension TerminationReasonExtension on TerminationReason {
  String get displayName {
    switch (this) {
      case TerminationReason.expired:
        return 'Hết hạn';
      case TerminationReason.violation:
        return 'Vi phạm';
      case TerminationReason.tenantRequest:
        return 'Yêu cầu của khách thuê';
      case TerminationReason.landlordRequest:
        return 'Yêu cầu của chủ nhà';
      case TerminationReason.other:
        return 'Khác';
    }
  }
}

class ContractEntity {
  const ContractEntity({
    required this.id,
    required this.roomId,
    this.tenantId,
    this.landlordId,
    this.contractNumber,
    required this.status,
    this.contractType,
    this.startDate,
    this.endDate,
    required this.monthlyRent,
    this.deposit = 0.0,
    this.paymentCycle,
    this.paymentFrequency,
    this.paymentDayType,
    this.paymentDay,
    this.paymentDays,
    this.autoRenewal,
    this.noticePeriodDays,
    this.specialTerms,
    this.signedByTenant,
    this.signedByLandlord,
    this.signedAt,
    this.terminationReason,
    this.terminationNote,
    this.isEarlyTermination,
    this.terms,
    required this.createdAt,
    this.updatedAt,
    this.roomCode,
    this.roomName,
    this.propertyAddress,
    this.propertyWard,
    this.propertyCity,
    this.propertyName,
  });

  final String id;
  final String roomId;
  final String? tenantId;
  final String? landlordId;
  final String? contractNumber;
  final String status;
  final String? contractType;
  final DateTime? startDate;
  final DateTime? endDate;
  final double monthlyRent;
  final double deposit;
  final String? paymentCycle;
  final int? paymentFrequency;
  final String? paymentDayType;
  final int? paymentDay;
  final List<dynamic>? paymentDays;
  final bool? autoRenewal;
  final int? noticePeriodDays;
  final String? specialTerms;
  final bool? signedByTenant;
  final bool? signedByLandlord;
  final DateTime? signedAt;
  final TerminationReason? terminationReason;
  final String? terminationNote;
  final bool? isEarlyTermination;
  final String? terms;
  final DateTime createdAt;
  final DateTime? updatedAt;
  // Room and property info
  final String? roomCode;
  final String? roomName;
  final String? propertyAddress;
  final String? propertyWard;
  final String? propertyCity;
  final String? propertyName;

  String get statusInVietnamese {
    switch (status.toUpperCase()) {
      case 'DRAFT':
        return 'Nháp';
      case 'ACTIVE':
        return 'Đang hoạt động';
      case 'EXPIRED':
        return 'Hết hạn';
      case 'TERMINATED':
        return 'Đã chấm dứt';
      default:
        return status;
    }
  }

  String get contractTypeInVietnamese {
    switch (contractType?.toUpperCase()) {
      case 'RENTAL':
        return 'Hợp đồng thuê';
      default:
        return contractType ?? 'Không xác định';
    }
  }

  String get paymentCycleInVietnamese {
    switch (paymentCycle?.toUpperCase()) {
      case 'MONTHLY':
        return 'Hàng tháng';
      case 'QUARTERLY':
        return 'Hàng quý';
      case 'YEARLY':
        return 'Hàng năm';
      default:
        return paymentCycle ?? 'Không xác định';
    }
  }

  String get paymentDayTypeInVietnamese {
    switch (paymentDayType?.toUpperCase()) {
      case 'FIXED_DAYS':
        return 'Ngày cố định';
      case 'CUSTOM_DAYS':
        return 'Ngày tùy chỉnh';
      default:
        return paymentDayType ?? 'Không xác định';
    }
  }

  bool get isTerminated => terminationReason != null || terminationNote != null;
  bool get hasSignature =>
      (signedByTenant ?? false) || (signedByLandlord ?? false);
  bool get isFullySigned =>
      (signedByTenant ?? false) && (signedByLandlord ?? false);

  /// Get formatted room info: "Tên phòng - Mã phòng"
  String get roomDisplayName {
    if (roomName != null && roomName!.isNotEmpty && roomCode != null) {
      return '$roomName - $roomCode';
    } else if (roomCode != null) {
      return roomCode!;
    } else if (roomName != null && roomName!.isNotEmpty) {
      return roomName!;
    }
    return 'N/A';
  }

  /// Get formatted address: "Địa chỉ, Ward, City"
  String get formattedAddress {
    final parts = <String>[];
    if (propertyAddress != null && propertyAddress!.isNotEmpty) {
      parts.add(propertyAddress!);
    }
    if (propertyWard != null && propertyWard!.isNotEmpty) {
      parts.add(propertyWard!);
    }
    if (propertyCity != null && propertyCity!.isNotEmpty) {
      parts.add(propertyCity!);
    }
    return parts.isNotEmpty ? parts.join(', ') : 'N/A';
  }
}
