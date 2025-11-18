import 'dart:async';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part '../../generated/core/services/auth_subscription_manager.g.dart';

@riverpod
class AuthSubscriptionManager extends _$AuthSubscriptionManager {
  StreamSubscription<AuthState>? _subscription;

  @override
  void build() {
    _subscription = Supabase.instance.client.auth.onAuthStateChange.listen(
      (data) {
        // Handle successful events if needed, e.g., logging
        debugPrint('Auth State Change: ${data.event}');
      },
      onError: (error) {
        debugPrint('Auth Stream Error: $error');
        if (error is AuthException) {
          // Here we can handle specific auth errors that occur on the stream
          // For now, we just print them. A more robust implementation could
          // involve showing a banner or attempting a graceful sign-out.
        }
      },
    );

    ref.onDispose(() {
      _subscription?.cancel();
    });
  }
}

