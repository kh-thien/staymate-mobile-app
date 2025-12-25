import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/localization/app_localizations_helper.dart';
import '../../../../core/services/locale_provider.dart';
import '../../../../core/permission/permission.dart';
import '../../domain/entities/contract.dart';
import '../providers/maintenance_request_provider.dart';

class CreateReportPage extends ConsumerStatefulWidget {
  const CreateReportPage({super.key});

  @override
  ConsumerState<CreateReportPage> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends ConsumerState<CreateReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _imagePicker = ImagePicker();

  String? _selectedPropertyId;
  String? _selectedRoomId;
  List<File> _selectedImages = [];
  bool _isSubmitting = false;
  static const int _maxImages = 3;
  String get _languageCode => ref.read(appLocaleProvider).languageCode;

  String _tr(String key) =>
      AppLocalizationsHelper.translate(key, _languageCode);

  String _trParams(String key, Map<String, String> params) =>
      AppLocalizationsHelper.translateWithParams(key, _languageCode, params);

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_selectedImages.length >= _maxImages) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_trParams('maxImagesHint', {'count': '$_maxImages'})),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    try {
      // Request photos permission before picking image
      final hasPermission = await PermissionHelper.requestPhotosWithFeedback(
        context,
      );

      if (!hasPermission) {
        return;
      }

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImages.add(File(image.path));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_trParams('imagePickerError', {'error': '$e'})),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _submit() async {
    print('🚀 [SUBMIT] Starting submit...');

    if (!_formKey.currentState!.validate()) {
      print('❌ [SUBMIT] Form validation failed');
      return;
    }

    if (_selectedPropertyId == null || _selectedRoomId == null) {
      print('❌ [SUBMIT] Property or Room not selected');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_tr('selectPropertyAndRoom')),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    if (!mounted) {
      print('❌ [SUBMIT] Widget not mounted');
      return;
    }

    print('✅ [SUBMIT] Setting isSubmitting = true');
    setState(() {
      _isSubmitting = true;
    });

    print('📤 [SUBMIT] Calling create with:');
    print('   - Property: $_selectedPropertyId');
    print('   - Room: $_selectedRoomId');
    print('   - Description: ${_descriptionController.text.trim()}');
    print('   - Images: ${_selectedImages.map((f) => f.path).toList()}');

    try {
      print('⏳ [SUBMIT] Calling ref.read...');
      // Gọi create function trực tiếp từ ref (không lưu notifier)
      await ref
          .read(maintenanceRequestCreatorProvider.notifier)
          .create(
            description: _descriptionController.text.trim(),
            propertiesId: _selectedPropertyId!,
            roomId: _selectedRoomId!,
            imagePaths: _selectedImages.isNotEmpty
                ? _selectedImages.map((f) => f.path).toList()
                : null,
          );

      print('✅ [SUBMIT] Create successful!');
      print('🔍 [SUBMIT] Mounted status: $mounted');

      // Nếu thành công, navigate về trang report ngay lập tức
      // để tránh disposed error
      if (mounted) {
        print('🔄 [SUBMIT] Navigating to /report');
        context.go('/report');

        print('📢 [SUBMIT] Scheduling snackbar...');
        // Show snackbar sau khi đã navigate
        Future.microtask(() {
          print('📢 [SUBMIT] Showing snackbar, mounted: $mounted');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_tr('reportSubmitSuccess')),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );
          } else {
            print('⚠️ [SUBMIT] Widget disposed, cannot show snackbar');
          }
        });
      } else {
        print('⚠️ [SUBMIT] Widget not mounted after create');
      }
    } catch (e, stackTrace) {
      print('❌ [SUBMIT] Error occurred: $e');
      print('📚 [SUBMIT] Stack trace: $stackTrace');
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_tr('error')}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final languageCode = ref.watch(appLocaleProvider).languageCode;
    final contractsAsync = ref.watch(activeContractsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          AppLocalizationsHelper.translate('createReport', languageCode),
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        child: contractsAsync.when(
          data: (contracts) {
            if (contracts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizationsHelper.translate(
                        'noContractsFound',
                        languageCode,
                      ),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            }

            // Debug log: Contracts loaded
            print('📊 [DEBUG] Contracts loaded: ${contracts.length} items');
            for (var contract in contracts) {
              print(
                '  - Property: ${contract.propertyId} (${contract.propertyName}), Room: ${contract.roomId} (${contract.roomCode})',
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.of(context).padding.bottom + 100,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF6C63FF).withOpacity(0.1),
                            const Color(0xFF6C63FF).withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF6C63FF).withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6C63FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.report_problem_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizationsHelper.translate(
                                    'reportIssue',
                                    languageCode,
                                  ),
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF6C63FF),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AppLocalizationsHelper.translate(
                                    'reportHeaderSubtitle',
                                    languageCode,
                                  ),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Property Dropdown
                    _PropertyDropdown(
                      contracts: contracts,
                      selectedPropertyId: _selectedPropertyId,
                      onChanged: (propertyId) {
                        print('✅ [DEBUG] Property selected: $propertyId');
                        setState(() {
                          _selectedPropertyId = propertyId;
                          _selectedRoomId = null; // Reset room selection
                          print(
                            '🔄 [DEBUG] State updated - Property: $_selectedPropertyId, Room: $_selectedRoomId',
                          );
                        });
                      },
                      languageCode: languageCode,
                    ),
                    const SizedBox(height: 16),

                    // Room Dropdown
                    _RoomDropdown(
                      contracts: contracts,
                      selectedPropertyId: _selectedPropertyId,
                      selectedRoomId: _selectedRoomId,
                      onChanged: (roomId) {
                        print('✅ [DEBUG] Room selected: $roomId');
                        setState(() {
                          _selectedRoomId = roomId;
                          print(
                            '🔄 [DEBUG] State updated - Property: $_selectedPropertyId, Room: $_selectedRoomId',
                          );
                        });
                      },
                      languageCode: languageCode,
                    ),
                    const SizedBox(height: 16),

                    // Description Field
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText:
                            '${AppLocalizationsHelper.translate('issueDescription', languageCode)} *',
                        hintText: AppLocalizationsHelper.translate(
                          'issueDescriptionHint',
                          languageCode,
                        ),
                        alignLabelWithHint: true,
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF6C63FF),
                            width: 2,
                          ),
                        ),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(bottom: 80),
                          child: Icon(
                            Icons.description_outlined,
                            color: Color(0xFF6C63FF),
                          ),
                        ),
                      ),
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppLocalizationsHelper.translate(
                            'pleaseEnterIssueDescription',
                            languageCode,
                          );
                        }
                        if (value.trim().length < 10) {
                          return AppLocalizationsHelper.translateWithParams(
                            'descriptionMinCharacters',
                            languageCode,
                            {'count': '10'},
                          );
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Image Picker
                    _ImagePicker(
                      selectedImages: _selectedImages,
                      maxImages: _maxImages,
                      onPickImage: _pickImage,
                      onRemoveImage: (index) {
                        setState(() {
                          _selectedImages.removeAt(index);
                        });
                      },
                      languageCode: languageCode,
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: SelectableText.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text:
                        '${AppLocalizationsHelper.translate('error', languageCode)}: ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  TextSpan(
                    text: error.toString(),
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 80,
        ),
        child: FloatingActionButton.extended(
          onPressed: _isSubmitting ? null : _submit,
          backgroundColor: const Color(0xFF6C63FF),
          elevation: 6,
          icon: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Icon(Icons.send_rounded, size: 22),
          label: Text(
            AppLocalizationsHelper.translate(
              _isSubmitting ? 'submitting' : 'submitReport',
              languageCode,
            ),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

class _PropertyDropdown extends StatelessWidget {
  final List<Contract> contracts;
  final String? selectedPropertyId;
  final ValueChanged<String?> onChanged;
  final String languageCode;

  const _PropertyDropdown({
    required this.contracts,
    required this.selectedPropertyId,
    required this.onChanged,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    // Group contracts by property
    final propertiesMap = <String, String>{};
    for (var contract in contracts) {
      if (contract.propertyId != null && contract.propertyName != null) {
        propertiesMap[contract.propertyId!] = contract.propertyName!;
      }
    }

    // Debug log: Properties map
    print('🏢 [DEBUG] Properties map: $propertiesMap');
    print('   Selected property ID: $selectedPropertyId');

    return DropdownButtonFormField<String>(
      value: selectedPropertyId,
      decoration: InputDecoration(
        labelText:
            '${AppLocalizationsHelper.translate('property', languageCode)} *',
        prefixIcon: const Icon(
          Icons.apartment_rounded,
          color: Color(0xFF6C63FF),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
        ),
      ),
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      hint: Text(
        AppLocalizationsHelper.translate(
          'selectPropertyPlaceholder',
          languageCode,
        ),
        style: const TextStyle(fontSize: 14),
      ),
      menuMaxHeight: 300,
      items: propertiesMap.entries.map((entry) {
        return DropdownMenuItem<String>(
          value: entry.key,
          child: Text(entry.value, style: const TextStyle(fontSize: 14)),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return AppLocalizationsHelper.translate(
            'pleaseSelectProperty',
            languageCode,
          );
        }
        return null;
      },
    );
  }
}

class _RoomDropdown extends StatelessWidget {
  final List<Contract> contracts;
  final String? selectedPropertyId;
  final String? selectedRoomId;
  final ValueChanged<String?> onChanged;
  final String languageCode;

  const _RoomDropdown({
    required this.contracts,
    required this.selectedPropertyId,
    required this.selectedRoomId,
    required this.onChanged,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    // Filter rooms by selected property
    final availableRooms = <String, String>{};
    if (selectedPropertyId != null) {
      for (var contract in contracts) {
        if (contract.propertyId == selectedPropertyId &&
            contract.roomId != null) {
          final roomLabel =
              contract.roomCode ??
              contract.roomName ??
              AppLocalizationsHelper.translate('unnamedRoom', languageCode);
          availableRooms[contract.roomId!] = roomLabel;
        }
      }
    }

    // Debug log: Available rooms
    print(
      '🚪 [DEBUG] Available rooms for property $selectedPropertyId: $availableRooms',
    );
    print('   Selected room ID: $selectedRoomId');

    return DropdownButtonFormField<String>(
      value: selectedRoomId,
      decoration: InputDecoration(
        labelText:
            '${AppLocalizationsHelper.translate('room', languageCode)} *',
        prefixIcon: const Icon(
          Icons.meeting_room_rounded,
          color: Color(0xFF6C63FF),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      hint: Text(
        selectedPropertyId == null
            ? AppLocalizationsHelper.translate(
                'selectPropertyFirst',
                languageCode,
              )
            : AppLocalizationsHelper.translate(
                'selectRoomPlaceholder',
                languageCode,
              ),
        style: const TextStyle(fontSize: 14),
      ),
      menuMaxHeight: 300,
      items: availableRooms.entries.map((entry) {
        return DropdownMenuItem<String>(
          value: entry.key,
          child: Text(entry.value, style: const TextStyle(fontSize: 14)),
        );
      }).toList(),
      onChanged: selectedPropertyId == null ? null : onChanged,
      validator: (value) {
        if (value == null) {
          return AppLocalizationsHelper.translate(
            'pleaseSelectRoom',
            languageCode,
          );
        }
        return null;
      },
    );
  }
}

class _ImagePicker extends StatelessWidget {
  final List<File> selectedImages;
  final VoidCallback onPickImage;
  final Function(int) onRemoveImage;
  final int maxImages;
  final String languageCode;

  const _ImagePicker({
    required this.selectedImages,
    required this.onPickImage,
    required this.onRemoveImage,
    this.maxImages = 3,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final maxImagesText = AppLocalizationsHelper.translateWithParams(
      'maxImagesHint',
      languageCode,
      {'count': '$maxImages'},
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              AppLocalizationsHelper.translate(
                'issueImagesOptional',
                languageCode,
              ),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                maxImagesText,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF6C63FF),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Placeholder khi chưa có ảnh nào
        if (selectedImages.isEmpty)
          InkWell(
            onTap: onPickImage,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 2,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_rounded,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizationsHelper.translate(
                        'addPhoto',
                        languageCode,
                      ),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      maxImagesText,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Grid hiển thị ảnh (chỉ hiện khi có ảnh)
        if (selectedImages.isNotEmpty)
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              // Các ảnh đã chọn
              ...selectedImages.asMap().entries.map((entry) {
                final index = entry.key;
                final image = entry.value;

                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        image,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => onRemoveImage(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),

              // Nút thêm ảnh (chỉ hiện nếu chưa đủ maxImages)
              if (selectedImages.length < maxImages)
                InkWell(
                  onTap: onPickImage,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_rounded,
                          size: 32,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppLocalizationsHelper.translate('add', languageCode),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
