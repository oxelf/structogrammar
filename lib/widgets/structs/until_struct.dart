import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/models/struct.dart';
import 'package:structogrammar/widgets/struct_drag_target.dart';
import 'package:structogrammar/widgets/struct_draggable.dart';

import '../../riverpod/state.dart';
import '../../riverpod/structs.dart';
import '../struct_builder.dart';

class UntilStructWidget extends ConsumerWidget {
  const UntilStructWidget({super.key, required this.struct, required this.maxWidth,});
  final Struct struct;
  final double maxWidth;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String selectedStruct = ref.watch(selectedStructPod);
    Struct? parent = ref.read(structsPod.notifier).findParentStruct(struct.id);
    TextStyle style = textStyleFromMap(struct.data, "text");
    bool parentIsIfStruct = (parent?.type ?? StructType.instruction) == StructType.ifSelect || (parent?.type ?? StructType.instruction) == StructType.loop || (parent?.type ?? StructType.instruction) == StructType.caseSelect;
    return  Container(
      width: maxWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          Row(children: [
            Container(width: 20,),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  for (int i = 0; i < struct.subStructs.length; i++) Column(
                    children: [
                      StructDragTarget(width: maxWidth - ((parentIsIfStruct)? 20: 24), structId: struct.id, index: i),
                      StructBuilder(struct: struct.subStructs[i], maxWidth: maxWidth - ((parentIsIfStruct)? 20: 24), noTopBorder: true, noRightBorder: true, bottomBorder: true, ),
                    ],
                  ),
                  StructDragTarget(width: maxWidth - 24, structId: struct.id, index: struct.subStructs.length),
                ],
              ),
            )
          ],), if ((struct.data["comment"] ?? "") != "") Padding(
            padding: const EdgeInsets.only(bottom: 2.0, left: 2),
            child: Text(struct.data["comment"].toString(), style: TextStyle(color: Colors.grey, fontSize: 12),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0, top: 2, bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(child: Text(struct.data["condition"].toString(), textAlign: TextAlign.center, overflow: TextOverflow.visible, style: style,)),
              ],
            ),
          ),
        ],
      ),
    );

  }
}