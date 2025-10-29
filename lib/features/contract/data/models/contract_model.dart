import 'package:json_annotation/json_annotation.dart';

part '../../../../generated/features/contract/data/models/contract_model.g.dart';

@JsonSerializable()
class ContractModel {
  const ContractModel({
    required this.id,
    required this.roomId,
    this.tenantId,
    this.contractNumber,
    required this.status,
    this.startDate,
    this.endDate,
    required this.monthlyRent,
    this.deposit = 0.0,
    this.paymentCycle,
    required this.createdAt,
  });

  final String id;
  @JsonKey(name: 'room_id')
  final String roomId;
  @JsonKey(name: 'tenant_id')
  final String? tenantId;
  @JsonKey(name: 'contract_number')
  final String? contractNumber;
  final String status;
  @JsonKey(name: 'start_date')
  final DateTime? startDate;
  @JsonKey(name: 'end_date')
  final DateTime? endDate;
  @JsonKey(name: 'monthly_rent')
  final double monthlyRent;
  final double deposit;
  @JsonKey(name: 'payment_cycle')
  final String? paymentCycle;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

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
}
