import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service để xử lý upload file/image lên Supabase Storage
class FileUploadService {
  final SupabaseClient _supabase;
  static const String bucketName = 'chat-files';
  static const int maxImageSize = 2048; // Max width/height for compression
  static const int imageQuality = 85; // JPEG quality (0-100)
  static const int maxFileSizeBytes = 52428800; // 50MB

  FileUploadService(this._supabase);

  /// Upload hình ảnh (tự động nén nếu cần)
  ///
  /// Returns: Public URL của file đã upload
  /// Throws: Exception nếu upload thất bại
  Future<FileUploadResult> uploadImage({
    required File file,
    required String roomId,
    required String messageId,
  }) async {
    try {
      print('📤 [FileUpload] Starting image upload...');
      print('📂 [FileUpload] Original path: ${file.path}');

      // Đọc file
      final bytes = await file.readAsBytes();
      print('📊 [FileUpload] Original size: ${_formatFileSize(bytes.length)}');

      // Kiểm tra kích thước
      if (bytes.length > maxFileSizeBytes) {
        throw Exception(
          'Kích thước file quá lớn (${_formatFileSize(bytes.length)}). '
          'Tối đa ${_formatFileSize(maxFileSizeBytes)}',
        );
      }

      // Nén hình ảnh
      final compressedBytes = await _compressImage(bytes);
      print(
        '✅ [FileUpload] Compressed: ${_formatFileSize(bytes.length)} → '
        '${_formatFileSize(compressedBytes.length)}',
      );

      // Tạo file path trong storage
      // Sau khi compress sẽ là JPEG, nên luôn dùng .jpg extension
      final fileName = path.basename(file.path);
      final storagePath = '$roomId/$messageId.jpg';

      print('☁️ [FileUpload] Uploading to: $bucketName/$storagePath');

      // Upload lên Supabase Storage
      await _supabase.storage
          .from(bucketName)
          .uploadBinary(
            storagePath,
            compressedBytes,
            fileOptions: const FileOptions(
              contentType: 'image/jpeg',
              upsert: true,
            ),
          );

      // Lấy public URL
      final publicUrl = _supabase.storage
          .from(bucketName)
          .getPublicUrl(storagePath);

      print('✅ [FileUpload] Upload success! URL: $publicUrl');

      return FileUploadResult(
        url: publicUrl,
        fileName: fileName,
        fileSize: compressedBytes.length,
      );
    } catch (e) {
      print('❌ [FileUpload] Upload failed: $e');
      rethrow;
    }
  }

  /// Upload file (không nén)
  ///
  /// Returns: Public URL của file đã upload
  /// Throws: Exception nếu upload thất bại
  Future<FileUploadResult> uploadFile({
    required File file,
    required String roomId,
    required String messageId,
  }) async {
    try {

      // Đọc file
      final bytes = await file.readAsBytes();
      final fileSize = bytes.length;
      print('📊 [FileUpload] File size: ${_formatFileSize(fileSize)}');

      // Kiểm tra kích thước
      if (fileSize > maxFileSizeBytes) {
        throw Exception(
          'Kích thước file quá lớn (${_formatFileSize(fileSize)}). '
          'Tối đa ${_formatFileSize(maxFileSizeBytes)}',
        );
      }

      // Tạo file path trong storage
      final fileName = path.basename(file.path);
      final ext = path.extension(fileName);
      final storagePath = '$roomId/$messageId$ext';

      print('☁️ [FileUpload] Uploading to: $bucketName/$storagePath');

      // Upload lên Supabase Storage
      await _supabase.storage
          .from(bucketName)
          .uploadBinary(
            storagePath,
            bytes,
            fileOptions: FileOptions(
              contentType: _getContentType(ext),
              upsert: true,
            ),
          );

      // Lấy public URL
      final publicUrl = _supabase.storage
          .from(bucketName)
          .getPublicUrl(storagePath);

      print('✅ [FileUpload] Upload success! URL: $publicUrl');

      return FileUploadResult(
        url: publicUrl,
        fileName: fileName,
        fileSize: fileSize,
      );
    } catch (e) {
      print('❌ [FileUpload] Upload failed: $e');
      rethrow;
    }
  }

  /// Nén hình ảnh để giảm kích thước
  Future<Uint8List> _compressImage(Uint8List bytes) async {
    return compute(_compressInIsolate, bytes);
  }

  /// Hàm nén chạy trong isolate riêng (không block UI)
  static Uint8List _compressInIsolate(Uint8List bytes) {
    // Decode image
    img.Image? image = img.decodeImage(bytes);
    if (image == null) {
      throw Exception('Không thể đọc hình ảnh');
    }

    // Resize nếu quá lớn
    if (image.width > maxImageSize || image.height > maxImageSize) {
      image = img.copyResize(
        image,
        width: image.width > image.height ? maxImageSize : null,
        height: image.height > image.width ? maxImageSize : null,
      );
    }

    // Encode lại thành JPEG với quality thấp hơn
    return Uint8List.fromList(img.encodeJpg(image, quality: imageQuality));
  }

  /// Xác định Content-Type dựa trên extension
  String _getContentType(String extension) {
    switch (extension.toLowerCase()) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      case '.heif':
      case '.heic':
        return 'image/heif';
      case '.pdf':
        return 'application/pdf';
      case '.doc':
      case '.docx':
        return 'application/msword';
      case '.xls':
      case '.xlsx':
        return 'application/vnd.ms-excel';
      case '.txt':
        return 'text/plain';
      default:
        return 'application/octet-stream';
    }
  }

  /// Format file size thành string dễ đọc
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

/// Kết quả upload file
class FileUploadResult {
  final String url;
  final String fileName;
  final int fileSize;

  const FileUploadResult({
    required this.url,
    required this.fileName,
    required this.fileSize,
  });
}
