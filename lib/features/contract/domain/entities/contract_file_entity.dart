class ContractFileEntity {
  const ContractFileEntity({
    required this.id,
    required this.contractId,
    required this.fileName,
    required this.filePath,
    required this.fileType,
    this.fileSize,
    this.description,
    required this.createdAt,
  });

  final String id;
  final String contractId;
  final String fileName;
  final String filePath;
  final String fileType;
  final int? fileSize;
  final String? description;
  final DateTime createdAt;

  // Helper getters
  bool get isImage {
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'];
    final ext = fileName.toLowerCase().split('.').last;
    return imageExtensions.contains(ext);
  }

  bool get isPdf => fileName.toLowerCase().endsWith('.pdf');

  String get fileSizeFormatted {
    if (fileSize == null) return '';

    final kb = fileSize! / 1024;
    if (kb < 1024) {
      return '${kb.toStringAsFixed(2)} KB';
    }

    final mb = kb / 1024;
    return '${mb.toStringAsFixed(2)} MB';
  }

  String get fileTypeDisplay {
    if (isImage) return 'Hình ảnh';
    if (isPdf) return 'PDF';
    return 'File';
  }
}
