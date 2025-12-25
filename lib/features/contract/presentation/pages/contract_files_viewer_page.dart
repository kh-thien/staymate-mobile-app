import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/permission/permission.dart';
import '../../../../core/services/locale_provider.dart';
import '../../../../core/localization/app_localizations_helper.dart';
import '../../data/models/contract_file_model.dart';

/// Full screen viewer for contract files with swipe navigation
class ContractFilesViewerPage extends ConsumerStatefulWidget {
  const ContractFilesViewerPage({
    super.key,
    required this.files,
    this.initialIndex = 0,
  });

  final List<ContractFileModel> files;
  final int initialIndex;

  @override
  ConsumerState<ContractFilesViewerPage> createState() =>
      _ContractFilesViewerPageState();
}

class _ContractFilesViewerPageState extends ConsumerState<ContractFilesViewerPage> {
  late PageController _pageController;
  late int _currentIndex;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _downloadCurrentFile() async {
    final currentFile = widget.files[_currentIndex];
    final url = supabase.storage
        .from('contracts')
        .getPublicUrl(currentFile.filePath);

    try {
      // Request storage permission using the service
      final hasPermission = await PermissionHelper.requestStorageWithFeedback(
        context,
      );

      if (hasPermission) {
        if (!mounted) return;

        final locale = ref.read(appLocaleProvider);
        final languageCode = locale.languageCode;

        // Show loading dialog and get its context
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

        // Download logic - Simple approach for both platforms
        final fileName = currentFile.originalName ?? currentFile.fileName;
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

            await dio.download(url, filePath);
            successMessage = AppLocalizationsHelper.translate(
              'savedToDownload',
              languageCode,
            );
          } else if (Platform.isIOS) {
            // iOS: Save to app documents directory
            // User can access via Files app -> On My iPhone -> StayMate
            final directory = await getApplicationDocumentsDirectory();
            filePath = '${directory.path}/$fileName';

            await dio.download(url, filePath);
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

          // Close loading dialog - Use rootNavigator to ensure dialog is closed
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
          // Close loading dialog if still open - use rootNavigator
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
        }
      }
      // Note: No need to handle permission denial here
      // PermissionHelper.requestStorageWithFeedback() already shows UI feedback
    } catch (e) {
      // Close loading dialog if open - use rootNavigator
      if (mounted) {
        try {
          Navigator.of(context, rootNavigator: true).pop();
        } catch (_) {
          // Dialog might already be closed
        }
      }

      // Show error message
      if (mounted) {
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
      body: Stack(
        children: [
          // Main content - File viewer
          PageView.builder(
            controller: _pageController,
            itemCount: widget.files.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final file = widget.files[index];
              final imageUrl = supabase.storage
                  .from('contracts')
                  .getPublicUrl(file.filePath);

              if (file.isImage) {
                // Image viewer with zoom
                return SafeArea(
                  bottom: true,
                  child: PhotoView(
                  imageProvider: NetworkImage(imageUrl),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                  heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
                  loadingBuilder: (context, event) => Center(
                    child: CircularProgressIndicator(
                      value: event == null
                          ? null
                          : event.cumulativeBytesLoaded /
                                (event.expectedTotalBytes ?? 1),
                    ),
                  ),
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 64, color: Colors.white54),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizationsHelper.translate(
                            'cannotLoadImage',
                            languageCode,
                          ),
                          style: const TextStyle(color: Colors.white54),
                        ),
                      ],
                      ),
                    ),
                  ),
                );
              } else {
                // PDF or other file type - show preview card
                return Center(
                  child: Card(
                    margin: const EdgeInsets.all(32),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            file.isPdf
                                ? Icons.picture_as_pdf
                                : Icons.insert_drive_file,
                            size: 100,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            file.originalName ?? file.fileName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            file.formattedFileSize,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () async {
                              // Download file first if not exists locally
                              try {
                                final tempDir = await getTemporaryDirectory();
                                final tempFilePath =
                                    '${tempDir.path}/${file.fileName}';
                                final tempFile = File(tempFilePath);

                                // Download if not cached
                                if (!await tempFile.exists()) {
                                  final dio = Dio();
                                  await dio.download(imageUrl, tempFilePath);
                                }

                                // Open file
                                final locale = ref.read(appLocaleProvider);
                                final languageCode = locale.languageCode;
                                final result = await OpenFilex.open(
                                  tempFilePath,
                                );
                                if (result.type != ResultType.done &&
                                    context.mounted) {
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
                              } catch (e) {
                                if (context.mounted) {
                                  final locale = ref.read(appLocaleProvider);
                                  final languageCode = locale.languageCode;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${AppLocalizationsHelper.translate('error', languageCode)}: ${e.toString()}',
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                            icon: const Icon(Icons.open_in_new),
                            label: Text(
                              AppLocalizationsHelper.translate(
                                'openFile',
                                languageCode,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          ),

          // Top bar - Close button and file info
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    // Close button
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                      tooltip: AppLocalizationsHelper.translate(
                        'close',
                        languageCode,
                      ),
                    ),
                    // File name and count
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.files[_currentIndex].originalName ??
                                widget.files[_currentIndex].fileName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${_currentIndex + 1} / ${widget.files.length}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Download button
                    IconButton(
                      onPressed: _downloadCurrentFile,
                      icon: const Icon(Icons.download, color: Colors.white),
                      tooltip: AppLocalizationsHelper.translate(
                        'download',
                        languageCode,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Page indicators (dots) - only show if multiple files
          if (widget.files.length > 1)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.files.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? Colors.white
                          : Colors.white38,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
