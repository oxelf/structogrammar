// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../models/struct.dart';
// import '../riverpod/state.dart';
//
// class StructDraggable extends ConsumerWidget {
//   const StructDraggable({super.key, required this.child, required this.data, required this.parentStructId, required this.index});
//   final Widget child;
//   final Struct data;
//   final String parentStructId;
//   final int index;
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Draggable<Struct>(data: data,
//         onDragStarted: () {
//           ref.read(showDragPod.notifier).state = true;
//           ref.read(dragStartIndexPod.notifier).state = index;
//           ref.read(dragStartStructIdPod.notifier).state = parentStructId;
//           ref.read(dragStructIdPod.notifier).state = data.id;
//         },onDragCompleted: () {
//           ref.read(showDragPod.notifier).state = false;
//           ref.read(dragStartIndexPod.notifier).state = null;
//           ref.read(dragStartStructIdPod.notifier).state = null;
//           ref.read(dragStructIdPod.notifier).state = null;
//         },onDraggableCanceled: (v, o) {
//           ref.read(showDragPod.notifier).state = false;
//           ref.read(dragStartIndexPod.notifier).state = null;
//           ref.read(dragStartStructIdPod.notifier).state = null;
//           ref.read(dragStructIdPod.notifier).state = null;
//         }, feedback: Material(child: child), child: child);
//   }
// }
