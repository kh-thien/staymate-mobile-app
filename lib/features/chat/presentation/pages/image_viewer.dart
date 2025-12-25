import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/ui_constants.dart';
import '../../../../core/permission/permission.dart';
import '../../../../core/services/locale_provider.dart';
import '../../../../core/localization/app_localizations_helper.dart';

/// Full-screen image viewer with zoom and pan
class ImageViewer extends ConsumerStatefulWidget {
  final String imageUrl;
  final String? fileName;

  const ImageViewer({super.key, required this.imageUrl, this.fileName});

  @override
  ConsumerState<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends ConsumerState<ImageViewer> {
  bool _isDownloading = false;

  Future<void> _downloadImage() async {
    if (_isDownloading) return;

    try {
      // Request storage permission
      final hasPermission = await PermissionHelper.requestStorageWithFeedback(
        context,
      );

      if (!hasPermission) {
        return;
      }

      if (!mounted) return;

      final locale = ref.read(appLocaleProvider);
      final languageCode = locale.languageCode;

      setState(() {
        _isDownloading = true;
      });

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizationsHelper.translate('downloading', languageCode),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Generate file name
      final fileName = widget.fileName ??
          'image_${DateTime.now().millisecondsSinceEpoch}.jpg';

      String successMessage;
      String? filePath;

      try {
        // Download file using Dio
        final dio = Dio();

        if (Platform.isAndroid) {
          // Android: Use Downloads folder
          final directory = Directory('/storage/emulated/0/Download');
          if (!await directory.exists()) {
            final externalDir = await getExternalStorageDirectory();
            if (externalDir == null) {
              throw Exception(
                AppLocalizationsHelper.translate(
                  'cannotAccessStorage',
                  languageCode,
                ),
              );
            }
            filePath = '${externalDir.path}/$fileName';
          } else {
            filePath = '${directory.path}/$fileName';
          }

          await dio.download(widget.imageUrl, filePath);
          successMessage = AppLocalizationsHelper.translate(
            'savedToDownload',
            languageCode,
          );
        } else if (Platform.isIOS) {
          // iOS: Save to app documents directory
          final directory = await getApplicationDocumentsDirectory();
          filePath = '${directory.path}/$fileName';

          await dio.download(widget.imageUrl, filePath);
          successMessage = AppLocalizationsHelper.translate(
            'savedToFiles',
            languageCode,
          );
        } else {
          throw Exception(
            AppLocalizationsHelper.translate(
              'platformNotSupported',
              languageCode,
            ),
          );
        }

        // Close loading dialog
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop();
        }

        // Wait a bit to ensure dialog is fully closed
        await Future.delayed(const Duration(milliseconds: 200));

        // Show success message
        if (mounted) {
          final locale = ref.read(appLocaleProvider);
          final languageCode = locale.languageCode;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(successMessage),
                  Text(fileName, style: const TextStyle(fontSize: 12)),
                ],
              ),
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: AppLocalizationsHelper.translate('open', languageCode),
                onPressed: () async {
                  final result = await OpenFilex.open(filePath!);
                  if (result.type != ResultType.done && mounted) {
                    final locale = ref.read(appLocaleProvider);
                    final languageCode = locale.languageCode;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          result.message.isNotEmpty
                              ? result.message
                              : AppLocalizationsHelper.translate(
                                  'cannotOpenFile',
                                  languageCode,
                                ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        }
      } catch (downloadError) {
        // Close loading dialog if still open
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop();
        }

        // Show download error
        if (mounted) {
          final locale = ref.read(appLocaleProvider);
          final languageCode = locale.languageCode;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${AppLocalizationsHelper.translate('errorDownloadingFile', languageCode)} ${downloadError.toString()}',
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isDownloading = false;
          });
        }
      }
    } catch (e) {
      // Close loading dialog if open
      if (mounted) {
        try {
          Navigator.of(context, rootNavigator: true).pop();
        } catch (_) {
          // Dialog might already be closed
        }
      }

      // Show error message
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
        final locale = ref.read(appLocaleProvider);
        final languageCode = locale.languageCode;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizationsHelper.translate('errorDownloadingFile', languageCode)} ${e.toString()}',
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(appLocaleProvider);
    final languageCode = locale.languageCode;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.fileName ??
              AppLocalizationsHelper.translate('image', languageCode),
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          // Download button
          IconButton(
            icon: _isDownloading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.download),
            onPressed: _isDownloading ? null : _downloadImage,
            tooltip: AppLocalizationsHelper.translate('download', languageCode),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: UIConstants.bottomNavHeight),
        child: PhotoView(
          imageProvider: CachedNetworkImageProvider(widget.imageUrl),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 3,
          loadingBuilder: (context, event) => Center(
            child: CircularProgressIndicator(
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
            ),
          ),
          errorBuilder: (context, error, stackTrace) => const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.broken_image, size: 64, color: Colors.white),
                SizedBox(height: 16),
                Text(
                  'Không thể tải hình ảnh',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
