import 'package:json_annotation/json_annotation.dart';
import '../../../../core/localization/app_localizations_helper.dart';

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
  /// Get translated termination reason based on language code
  String getTranslated(String languageCode) {
    switch (this) {
      case TerminationReason.expired:
        return AppLocalizationsHelper.translate('terminationReasonExpired', languageCode);
      case TerminationReason.violation:
        return AppLocalizationsHelper.translate('terminationReasonViolation', languageCode);
      case TerminationReason.tenantRequest:
        return AppLocalizationsHelper.translate('terminationReasonTenantRequest', languageCode);
      case TerminationReason.landlordRequest:
        return AppLocalizationsHelper.translate('terminationReasonLandlordRequest', languageCode);
      case TerminationReason.other:
        return AppLocalizationsHelper.translate('terminationReasonOther', languageCode);
    }
  }

  // Deprecated: Keep for backward compatibility, but use getTranslated instead
  @Deprecated('Use getTranslated instead')
  String get displayName {
    return getTranslated('vi');
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

  /// Get translated status based on language code
  String getStatusTranslated(String languageCode) {
    switch (status.toUpperCase()) {
      case 'DRAFT':
        return AppLocalizationsHelper.translate('contractStatusDraft', languageCode);
      case 'ACTIVE':
        return AppLocalizationsHelper.translate('contractStatusActive', languageCode);
      case 'EXPIRED':
        return AppLocalizationsHelper.translate('contractStatusExpired', languageCode);
      case 'TERMINATED':
        return AppLocalizationsHelper.translate('contractStatusTerminated', languageCode);
      default:
        return status;
    }
  }

  /// Get translated contract type based on language code
  String getContractTypeTranslated(String languageCode) {
    switch (contractType?.toUpperCase()) {
      case 'RENTAL':
        return AppLocalizationsHelper.translate('contractTypeRental', languageCode);
      default:
        return AppLocalizationsHelper.translate('contractTypeUnknown', languageCode);
    }
  }

  /// Get translated payment cycle based on language code
  String getPaymentCycleTranslated(String languageCode) {
    switch (paymentCycle?.toUpperCase()) {
      case 'MONTHLY':
        return AppLocalizationsHelper.translate('paymentCycleMonthly', languageCode);
      case 'QUARTERLY':
        return AppLocalizationsHelper.translate('paymentCycleQuarterly', languageCode);
      case 'YEARLY':
        return AppLocalizationsHelper.translate('paymentCycleYearly', languageCode);
      default:
        return AppLocalizationsHelper.translate('paymentCycleUnknown', languageCode);
    }
  }

  /// Get translated payment day type based on language code
  String getPaymentDayTypeTranslated(String languageCode) {
    switch (paymentDayType?.toUpperCase()) {
      case 'FIXED_DAYS':
        return AppLocalizationsHelper.translate('paymentDayTypeFixedDays', languageCode);
      case 'CUSTOM_DAYS':
        return AppLocalizationsHelper.translate('paymentDayTypeCustomDays', languageCode);
      default:
        return AppLocalizationsHelper.translate('paymentDayTypeUnknown', languageCode);
    }
  }

  // Deprecated: Keep for backward compatibility, but use getStatusTranslated instead
  @Deprecated('Use getStatusTranslated instead')
  String get statusInVietnamese {
    return getStatusTranslated('vi');
  }

  // Deprecated: Keep for backward compatibility, but use getContractTypeTranslated instead
  @Deprecated('Use getContractTypeTranslated instead')
  String get contractTypeInVietnamese {
    return getContractTypeTranslated('vi');
    }

  // Deprecated: Keep for backward compatibility, but use getPaymentCycleTranslated instead
  @Deprecated('Use getPaymentCycleTranslated instead')
  String get paymentCycleInVietnamese {
    return getPaymentCycleTranslated('vi');
  }

  // Deprecated: Keep for backward compatibility, but use getPaymentDayTypeTranslated instead
  @Deprecated('Use getPaymentDayTypeTranslated instead')
  String get paymentDayTypeInVietnamese {
    return getPaymentDayTypeTranslated('vi');
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
