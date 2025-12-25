import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/contract_entity.dart';

part '../../../../generated/features/contract/data/models/contract_model.g.dart';

@JsonSerializable()
class ContractModel {
  const ContractModel({
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
  @JsonKey(name: 'room_id')
  final String roomId;
  @JsonKey(name: 'tenant_id')
  final String? tenantId;
  @JsonKey(name: 'landlord_id')
  final String? landlordId;
  @JsonKey(name: 'contract_number')
  final String? contractNumber;
  final String status;
  @JsonKey(name: 'contract_type')
  final String? contractType;
  @JsonKey(name: 'start_date')
  final DateTime? startDate;
  @JsonKey(name: 'end_date')
  final DateTime? endDate;
  @JsonKey(name: 'monthly_rent')
  final double monthlyRent;
  final double deposit;
  @JsonKey(name: 'payment_cycle')
  final String? paymentCycle;
  @JsonKey(name: 'payment_frequency')
  final int? paymentFrequency;
  @JsonKey(name: 'payment_day_type')
  final String? paymentDayType;
  @JsonKey(name: 'payment_day')
  final int? paymentDay;
  @JsonKey(name: 'payment_days')
  final List<dynamic>? paymentDays;
  @JsonKey(name: 'auto_renewal')
  final bool? autoRenewal;
  @JsonKey(name: 'notice_period_days')
  final int? noticePeriodDays;
  @JsonKey(name: 'special_terms')
  final String? specialTerms;
  @JsonKey(name: 'signed_by_tenant')
  final bool? signedByTenant;
  @JsonKey(name: 'signed_by_landlord')
  final bool? signedByLandlord;
  @JsonKey(name: 'signed_at')
  final DateTime? signedAt;
  @JsonKey(name: 'termination_reason', unknownEnumValue: null)
  final TerminationReason? terminationReason;
  @JsonKey(name: 'termination_note')
  final String? terminationNote;
  @JsonKey(name: 'is_early_termination')
  final bool? isEarlyTermination;
  final String? terms;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  // Room and property info (from join)
  @JsonKey(name: 'room_code', includeFromJson: true, includeToJson: false)
  final String? roomCode;
  @JsonKey(name: 'room_name', includeFromJson: true, includeToJson: false)
  final String? roomName;
  @JsonKey(name: 'property_address', includeFromJson: true, includeToJson: false)
  final String? propertyAddress;
  @JsonKey(name: 'property_ward', includeFromJson: true, includeToJson: false)
  final String? propertyWard;
  @JsonKey(name: 'property_city', includeFromJson: true, includeToJson: false)
  final String? propertyCity;
  @JsonKey(name: 'property_name', includeFromJson: true, includeToJson: false)
  final String? propertyName;

  factory ContractModel.fromJson(Map<String, dynamic> json) =>
      _$ContractModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContractModelToJson(this);

  String get statusInVietnamese {
    switch (status) {
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

  // Convert to Entity
  ContractEntity toEntity() {
    return ContractEntity(
      id: id,
      roomId: roomId,
      tenantId: tenantId,
      landlordId: landlordId,
      contractNumber: contractNumber,
      status: status,
      contractType: contractType,
      startDate: startDate,
      endDate: endDate,
      monthlyRent: monthlyRent,
      deposit: deposit,
      paymentCycle: paymentCycle,
      paymentFrequency: paymentFrequency,
      paymentDayType: paymentDayType,
      paymentDay: paymentDay,
      paymentDays: paymentDays,
      autoRenewal: autoRenewal,
      noticePeriodDays: noticePeriodDays,
      specialTerms: specialTerms,
      signedByTenant: signedByTenant,
      signedByLandlord: signedByLandlord,
      signedAt: signedAt,
      terminationReason: terminationReason,
      terminationNote: terminationNote,
      isEarlyTermination: isEarlyTermination,
      terms: terms,
      createdAt: createdAt,
      updatedAt: updatedAt,
      roomCode: roomCode,
      roomName: roomName,
      propertyAddress: propertyAddress,
      propertyWard: propertyWard,
      propertyCity: propertyCity,
      propertyName: propertyName,
    );
  }
}
