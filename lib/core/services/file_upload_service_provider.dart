import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stay_mate/core/network/supabase_client.dart';
import 'package:stay_mate/core/services/file_upload_service.dart';

part '../../generated/core/services/file_upload_service_provider.g.dart';

@riverpod
FileUploadService fileUploadService(Ref ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return FileUploadService(supabase);
}
