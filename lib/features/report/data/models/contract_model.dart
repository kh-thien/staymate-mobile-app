import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/contract.dart';

part '../../../../generated/features/report/data/models/contract_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ContractModel {
  final String id;
  final String? roomId;
  final String? tenantId;
  final String? landlordId;
  final String? contractNumber;
  final String status;
  final DateTime? startDate;
  final DateTime? endDate;

  // Join fields
  final String? propertyId;
  final String? roomCode;
  final String? roomName;
  final String? propertyName;

  const ContractModel({
    required this.id,
    this.roomId,
    this.tenantId,
    this.landlordId,
    this.contractNumber,
    required this.status,
    this.startDate,
    this.endDate,
    this.propertyId,
    this.roomCode,
    this.roomName,
    this.propertyName,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) =>
      _$ContractModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContractModelToJson(this);

  Contract toEntity() {
    return Contract(
      id: id,
      roomId: roomId,
      tenantId: tenantId,
      propertyId: propertyId,
      contractNumber: contractNumber ?? '',
      status: status,
      startDate: startDate,
      endDate: endDate,
      roomCode: roomCode,
      roomName: roomName,
      propertyName: propertyName,
    );
  }
}
