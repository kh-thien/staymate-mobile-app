import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../../generated/shared/providers/app_bar_provider.g.dart';

class AppBarState {
  final String? title;
  final List<Widget>? actions;

  AppBarState({this.title, this.actions});
}

@riverpod
class AppBarNotifier extends _$AppBarNotifier {
  @override
  AppBarState build() {
    return AppBarState(title: null, actions: null); // Initial state
  }

  void updateTitle(String? title) {
    state = AppBarState(title: title, actions: state.actions);
  }

  void updateActions(List<Widget>? actions) {
    state = AppBarState(title: state.title, actions: actions);
  }

  void updateAll({String? title, List<Widget>? actions}) {
    state = AppBarState(title: title, actions: actions);
  }

  void reset() {
    state = AppBarState(title: null, actions: null);
  }
}
