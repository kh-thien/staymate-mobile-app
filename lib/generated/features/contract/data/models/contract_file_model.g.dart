// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../features/contract/data/models/contract_file_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContractFileModel _$ContractFileModelFromJson(Map<String, dynamic> json) =>
    ContractFileModel(
      id: json['id'] as String,
      contractId: json['contract_id'] as String,
      fileName: json['file_name'] as String,
      filePath: json['file_path'] as String,
      originalName: json['original_name'] as String?,
      fileType: json['file_type'] as String?,
      fileSize: (json['file_size'] as num?)?.toInt(),
      uploadOrder: (json['upload_order'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ContractFileModelToJson(ContractFileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'contract_id': instance.contractId,
      'file_name': instance.fileName,
      'file_path': instance.filePath,
      'original_name': instance.originalName,
      'file_type': instance.fileType,
      'file_size': instance.fileSize,
      'upload_order': instance.uploadOrder,
      'created_at': instance.createdAt.toIso8601String(),
    };
