import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/riverpod/code_notifier.dart';
import 'package:structogrammar/riverpod/state.dart';
import 'package:structogrammar/util/uuid.dart';

import '../models/struct.dart';
import '../riverpod/structs.dart';

class StructDragTarget extends ConsumerWidget {
  const StructDragTarget(
      {super.key,
      required this.width,
      required this.structId,
      required this.index});

  final double width;
  final String structId;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool showDrag = ref.watch(showDragPod);
    String? startStructId = ref.watch(dragStartStructIdPod);
    int? dragStartIndex = ref.watch(dragStartIndexPod);
    return (showDrag &&
            !(startStructId.toString() == structId &&
                (dragStartIndex == index ||
                    ((dragStartIndex ?? 0) + 1) == index)))
        ? DragTarget<Struct>(
            builder: (context, candidateItems, rejectedItems) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2),
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(2),
                  padding: EdgeInsets.all(0),
                  dashPattern: [2, 4],
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    child: Container(
                      height: 20,
                      width: width - 4,
                      child: Center(
                          child: Icon(
                        Icons.add,
                        size: 14,
                      )),
                    ),
                  ),
                ),
              );
            },
            onMove: (details) {},
            onAcceptWithDetails: (details) {
              ref.read(structsPod.notifier).removeStruct(details.data.id);
              Struct newStruct = details.data.copyWith();
              newStruct.id = generateUUID();
              ref
                  .read(structsPod.notifier)
                  .insertSubStruct(structId, newStruct, index);
              Struct? rootStruct =
                  ref.read(structsPod.notifier).findRootStruct(structId);
              if (rootStruct != null) {
                ref.read(codePod.notifier).generate(rootStruct);
              }
            },
          )
        : SizedBox();
  }
}
