import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class HierarchyNotifier extends Notifier<Map<String, bool>> {
  @override
  Map<String, bool> build() {
    return {};
  }

  void click(String id) {
    Map<String, bool> newState = state;
    var val = newState[id];
    if (val == true) {
      newState[id] = false;
    } else {
      newState[id] = true;
    }
    state = newState;
  }
}

final hierarchyPod = NotifierProvider<HierarchyNotifier, Map<String, bool>>(() {
  return HierarchyNotifier();
});


final hierarchyDragPositionPod = StateProvider<Offset?>((ref) {
  return null;
});

final hierarchyDragTargetLocationPod = StateProvider<(String, String)?>((ref) {
  return null;
});