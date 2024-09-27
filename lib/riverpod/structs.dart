import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/models/struct.dart';
import 'package:structogrammar/riverpod/managers.dart';

class StructsId {
  static int id = 100000;

  static int getId() {
    id++;
    return id;
  }
}

final selectedStructPod = StateProvider<int?>((ref) {
  return null;
});

final structDragCoordinatesPod = StateProvider<Offset?>((ref) {
  return null;
});

final structCopyPod = StateProvider<Struct?>((ref) {
  return null;
});

enum StructDragLocation { before, after }

final structDragTargetLocationPod =
    StateProvider<(int, StructDragLocation)?>((ref) {
  return null;
});




final selectedStructStreamPod  = StreamProvider<Struct>((ref) async* {
  final manager = await ref.watch(structManagerPod.future);
  final selectedStruct = ref.watch(selectedStructPod);
  if (selectedStruct != null) {
    final struct = await manager.getStruct(selectedStruct);
   if (struct != null) yield struct;
  }
});