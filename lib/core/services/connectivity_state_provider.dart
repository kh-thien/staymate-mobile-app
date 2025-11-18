import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../../generated/core/services/connectivity_state_provider.g.dart';

enum ConnectivityStatus {
  connected,
  reconnecting,
  disconnected,
}

@Riverpod(keepAlive: true)
class ConnectivityState extends _$ConnectivityState {
  @override
  ConnectivityStatus build() {
    return ConnectivityStatus.connected;
  }

  void setReconnecting() {
    state = ConnectivityStatus.reconnecting;
  }

  void setConnected() {
    state = ConnectivityStatus.connected;
  }

  void setDisconnected() {
    state = ConnectivityStatus.disconnected;
  }
}

