import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:screenshot/screenshot.dart';
import 'package:structogrammar/models/struct.dart';
import 'package:structogrammar/widgets/struct_draggable.dart';

import '../../riverpod/state.dart';
import '../../riverpod/structs.dart';
import '../struct_builder.dart';
import '../struct_drag_target.dart';

class ForStructWidget extends ConsumerWidget {
  const ForStructWidget({super.key, required this.struct, required this.maxWidth,});
  final Struct struct;
  final double maxWidth;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String selectedStruct = ref.watch(selectedStructPod);
    Struct? parent = ref.read(structsPod.notifier).findParentStruct(struct.id);
    bool parentIsIfStruct = (parent?.type ?? StructType.instruction) == StructType.ifSelect || (parent?.type ?? StructType.instruction) == StructType.loop;
    bool showDrag = ref.watch(showDragPod);
    String? color = struct.data["color"];
    return  Container(
      width: maxWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if ((struct.data["comment"] ?? "") != "") Padding(
            padding: const EdgeInsets.only(bottom: 2.0, left: 2),
            child: Text(struct.data["comment"].toString(), style: TextStyle(color: Colors.grey, fontSize: 12),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0, top: 2, bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(child: Text(struct.data["condition"].toString(), textAlign: TextAlign.center, overflow: TextOverflow.visible, style: TextStyle(fontSize: 12),)),
              ],
            ),
          ),
          Row(
            children: [
              Container(width: 20,),
              Expanded(child: Container( height: 2, color: Colors.black,)),
            ],
          ),
          Container(
            width: maxWidth,
            color: ((selectedStruct == struct.id)
    ? Colors.orangeAccent
        : (color != null)? HexColor(color): Colors.white),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                Container(width: 20,),
                Container(width: 2, color: Colors.black,),
                Expanded(
                  child: Column(
                    children: [
                      for (int i = 0; i < struct.subStructs.length; i++) Column(
                        children: [
                          StructDragTarget(
                              width: maxWidth - ((parentIsIfStruct)? 22: 26), structId: struct.id, index: i),
                          StructDraggable(index: i, data: struct.subStructs[i], parentStructId: struct.id, child: StructBuilder(struct: struct.subStructs[i], maxWidth: maxWidth- ((parentIsIfStruct)? 22: 26), noTopBorder: (showDrag || i == 0), noRightBorder: true, noLeftBorder: true, bottomBorder: showDrag,)),
                        ],
                      ),
                      StructDragTarget(
                          width: maxWidth - ((parentIsIfStruct)? 22: 26), structId: struct.id, index: struct.subStructs.length),
                    ],
                  ),
                )
              ],),
            ),
          )
        ],
      ),
    );

  }
}