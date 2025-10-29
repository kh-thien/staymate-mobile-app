import 'contract_entity.dart';
import 'room_entity.dart';
import 'property_entity.dart';
import 'contract_file_entity.dart';
import '../../../auth/domain/entities/user.dart';

class ContractDetailEntity {
  const ContractDetailEntity({
    required this.contract,
    this.room,
    this.property,
    this.tenant,
    this.files = const [],
  });

  final ContractEntity contract;
  final RoomEntity? room;
  final PropertyEntity? property;
  final User? tenant;
  final List<ContractFileEntity> files;

  // Helper getters
  List<ContractFileEntity> get imageFiles =>
      files.where((f) => f.isImage).toList();

  List<ContractFileEntity> get pdfFiles => files.where((f) => f.isPdf).toList();

  bool get hasImages => imageFiles.isNotEmpty;

  bool get hasPdfFiles => pdfFiles.isNotEmpty;

  String get roomDisplayName => room?.displayName ?? 'Không có thông tin';

  String get propertyDisplayName => property?.name ?? 'Không có thông tin';

  String get tenantDisplayName => tenant?.fullName ?? 'Không có thông tin';

  String get displayName =>
      contract.contractNumber ?? 'Hợp đồng #${contract.id.substring(0, 8)}';
}
