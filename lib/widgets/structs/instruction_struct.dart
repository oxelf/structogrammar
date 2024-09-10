import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/models/struct.dart';

import '../../riverpod/state.dart';
import '../struct_builder.dart';

class InstructionStructWidget extends ConsumerWidget {
  const InstructionStructWidget({super.key, required this.struct, required this.maxWidth,});
  final Struct struct;
  final double maxWidth;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String selectedStruct = ref.watch(selectedStructPod);
    TextStyle style = textStyleFromMap(struct.data, "text");
    TextStyle commentStyle = textStyleFromMap(struct.data, "comment");
    return  Container(
      width: maxWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if ((struct.data["comment"] ?? "") != "") Padding(
          padding: const EdgeInsets.only(bottom: 2.0, left: 2),
          child: Text(struct.data["comment"].toString(), style: commentStyle,),
        ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0, top: 2, bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(child: Text(struct.data["instruction"].toString(), overflow: TextOverflow.visible, style: style)),
              ],
            ),
          ),
        ],
      ),
    );

  }
}