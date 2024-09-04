import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedStructPod = StateProvider<String>((ref) {
  return "entry_instruction";
});


final tabControllerPod = StateProvider<TabController?>((ref) {
  return null;
});

final pageControllerPod = StateProvider<PageController>((ref) {
  return PageController();
});

final cursorPod = StateProvider<SystemMouseCursor>((ref) {
  return SystemMouseCursors.basic;
});

final showDragPod = StateProvider<bool>((ref) {
  return false;
});

final dragStartStructIdPod = StateProvider<String?>((ref) {
  return null;
});

final dragStructIdPod = StateProvider<String?>((ref) {
  return null;
});


final dragStartIndexPod = StateProvider<int?>((ref) {
  return null;
});