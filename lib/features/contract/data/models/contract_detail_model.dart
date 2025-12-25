import 'package:json_annotation/json_annotation.dart';
import 'contract_model.dart';
import 'room_model.dart';
import 'property_model.dart';
import 'tenant_model.dart';
import 'contract_file_model.dart';
import '../../domain/entities/contract_detail_entity.dart';

part '../../../../generated/features/contract/data/models/contract_detail_model.g.dart';

@JsonSerializable()
class ContractDetailModel {
  const ContractDetailModel({
    required this.contract,
    this.room,
    this.property,
    this.tenant,
    this.files = const [],
  });

  final ContractModel contract;
  final RoomModel? room;
  final PropertyModel? property;
  final TenantModel? tenant;
  final List<ContractFileModel> files;

  factory ContractDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ContractDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContractDetailModelToJson(this);

  // Convert to Entity
  ContractDetailEntity toEntity() {
    return ContractDetailEntity(
      contract: contract.toEntity(),
      room: room?.toEntity(),
      property: property?.toEntity(),
      tenant: tenant?.toEntity(),
      files: files.map((f) => f.toEntity()).toList(),
    );
  }
}
