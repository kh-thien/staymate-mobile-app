// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../core/services/file_upload_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fileUploadService)
const fileUploadServiceProvider = FileUploadServiceProvider._();

final class FileUploadServiceProvider
    extends
        $FunctionalProvider<
          FileUploadService,
          FileUploadService,
          FileUploadService
        >
    with $Provider<FileUploadService> {
  const FileUploadServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fileUploadServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fileUploadServiceHash();

  @$internal
  @override
  $ProviderElement<FileUploadService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FileUploadService create(Ref ref) {
    return fileUploadService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FileUploadService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FileUploadService>(value),
    );
  }
}

String _$fileUploadServiceHash() => r'1294689cd61d41e398e6653f7dcf493a6aa5bb43';
