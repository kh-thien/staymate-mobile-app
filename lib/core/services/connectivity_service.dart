import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../../generated/core/services/connectivity_service.g.dart';

/// Service để kiểm tra trạng thái kết nối internet
class ConnectivityService {
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  ConnectivityService(this._connectivity);

  /// Kiểm tra trạng thái kết nối hiện tại
  Future<bool> checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return _isConnected(result);
    } catch (e) {
      // Nếu có lỗi, giả định là có kết nối để không block UI
      // (hoặc return false nếu muốn nghiêm ngặt hơn)
      return true;
    }
  }

  /// Stream trạng thái kết nối
  Stream<bool> get connectivityStream {
    try {
      return _connectivity.onConnectivityChanged
          .map((results) => _isConnected(results));
    } catch (e) {
      // Nếu có lỗi khi tạo stream, return stream với giá trị mặc định
      return Stream.value(true);
    }
  }

  /// Kiểm tra xem có kết nối internet không
  bool _isConnected(List<ConnectivityResult> results) {
    return results.any(
      (result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet,
    );
  }

  void dispose() {
    _subscription?.cancel();
  }
}

/// Provider cho ConnectivityService
@riverpod
ConnectivityService connectivityService(Ref ref) {
  final connectivity = Connectivity();
  final service = ConnectivityService(connectivity);
  ref.onDispose(() => service.dispose());
  return service;
}

/// Provider để kiểm tra trạng thái kết nối hiện tại
@riverpod
Future<bool> connectivityStatus(Ref ref) async {
  final service = ref.watch(connectivityServiceProvider);
  return service.checkConnectivity();
}

/// Provider để theo dõi trạng thái kết nối real-time
@riverpod
Stream<bool> connectivityStream(Ref ref) async* {
  try {
    final service = ref.watch(connectivityServiceProvider);
    // Listen vào stream và forward events
    await for (final value in service.connectivityStream) {
      yield value;
    }
  } catch (e) {
    // Khi có lỗi (ví dụ: MissingPluginException), 
    // yield giá trị mặc định là true (online)
    // để không block UI khi plugin chưa sẵn sàng
    yield true;
    // Sau đó không yield thêm gì nữa (stream sẽ kết thúc)
  }
}

