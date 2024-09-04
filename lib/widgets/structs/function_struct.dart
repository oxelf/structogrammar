import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/models/struct.dart';
import 'package:structogrammar/riverpod/structs.dart';
import 'package:structogrammar/widgets/struct_drag_target.dart';
import 'package:structogrammar/widgets/struct_draggable.dart';

import '../../riverpod/state.dart';
import '../struct_builder.dart';

class FunctionStructWidget extends ConsumerWidget {
  const FunctionStructWidget(
      {super.key, required this.struct, required this.maxWidth});

  final Struct struct;
  final double maxWidth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String selectedStruct = ref.watch(selectedStructPod);
    bool showDrag = ref.watch(showDragPod);
    return Column(
      children: [
        if ((struct.data["comment"] ?? "") != "")
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 4),
                child: Text(
                  struct.data["comment"].toString(),
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                struct.data["name"].toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
        ),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 10,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (int i = 0; i < struct.subStructs.length; i++)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          StructDragTarget(
                              width: maxWidth - 20, structId: struct.id, index: i),
                          StructDraggable(
                              data: struct.subStructs[i],
                              index: i,
                              parentStructId: struct.id,
                              child: StructBuilder(
                                struct: struct.subStructs[i],
                                maxWidth: maxWidth - 20,
                                bottomBorder: (showDrag)
                                    ? true
                                    : (i + 1 == struct.subStructs.length)
                                        ? true
                                        : null,
                              )),
                        ],
                      ),
                    StructDragTarget(
                        width: maxWidth - 20, structId: struct.id, index: struct.subStructs.length),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}