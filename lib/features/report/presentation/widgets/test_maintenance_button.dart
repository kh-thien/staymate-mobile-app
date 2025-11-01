import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/maintenance_request_provider.dart';

/// Simple test button to verify maintenance records are fetched
/// Add this to your ReportPage or any debug page
class TestMaintenanceButton extends ConsumerWidget {
  const TestMaintenanceButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () async {
        try {
          print('🔍 [TEST] Fetching maintenance records...');

          final maintenances = await ref.read(
            maintenanceRecordsProvider.future,
          );

          print('✅ [TEST] Found ${maintenances.length} maintenance records:');
          for (var m in maintenances) {
            print('  - ${m.title} (${m.status})');
            if (m.maintenanceRequestId != null) {
              print('    📋 From request: ${m.maintenanceRequestId}');
            }
          }

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '✅ Tìm thấy ${maintenances.length} công việc bảo trì',
                ),
                backgroundColor: Colors.green,
              ),
            );
          }
        } catch (e) {
          print('❌ [TEST] Error: $e');
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('❌ Lỗi: $e'), backgroundColor: Colors.red),
            );
          }
        }
      },
      icon: const Icon(Icons.bug_report),
      label: const Text('TEST: Fetch Maintenance'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
    );
  }
}
