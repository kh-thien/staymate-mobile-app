import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/contract_file_entity.dart';

part '../../../../generated/features/contract/data/models/contract_file_model.g.dart';

@JsonSerializable()
class ContractFileModel {
  const ContractFileModel({
    required this.id,
    required this.contractId,
    required this.fileName,
    required this.filePath,
    this.originalName,
    this.fileType,
    this.fileSize,
    this.uploadOrder,
    required this.createdAt,
  });

  final String id;
  @JsonKey(name: 'contract_id')
  final String contractId;
  @JsonKey(name: 'file_name')
  final String fileName;
  @JsonKey(name: 'file_path')
  final String filePath;
  @JsonKey(name: 'original_name')
  final String? originalName;
  @JsonKey(name: 'file_type')
  final String? fileType;
  @JsonKey(name: 'file_size')
  final int? fileSize;
  @JsonKey(name: 'upload_order')
  final int? uploadOrder;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  // Helper để check file type
  bool get isImage {
    if (fileType == null) return false;
    return fileType!.toLowerCase().startsWith('image/');
  }

  bool get isPdf {
    if (fileType == null) return false;
    return fileType!.toLowerCase() == 'application/pdf';
  }

  // Format file size
  String get formattedFileSize {
    if (fileSize == null) return 'N/A';
    final kb = fileSize! / 1024;
    if (kb < 1024) {
      return '${kb.toStringAsFixed(1)} KB';
    }
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(1)} MB';
  }

  factory ContractFileModel.fromJson(Map<String, dynamic> json) =>
      _$ContractFileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContractFileModelToJson(this);

  // Convert to Entity
  ContractFileEntity toEntity() {
    return ContractFileEntity(
      id: id,
      contractId: contractId,
      fileName: originalName ?? fileName,
      filePath: filePath,
      fileType: fileType ?? 'unknown',
      fileSize: fileSize,
      createdAt: createdAt,
    );
  }
}
