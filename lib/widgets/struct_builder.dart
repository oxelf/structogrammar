import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:screenshot/screenshot.dart';
import 'package:structogrammar/models/struct.dart';
import 'package:structogrammar/riverpod/code_notifier.dart';
import 'package:structogrammar/riverpod/state.dart';
import 'package:structogrammar/riverpod/structs.dart';
import 'package:structogrammar/widgets/context_menu.dart';
import 'package:structogrammar/widgets/structs/case_struct.dart';
import 'package:structogrammar/widgets/structs/for_struct.dart';
import 'package:structogrammar/widgets/structs/function_struct.dart';
import 'package:structogrammar/widgets/structs/if_struct.dart';
import 'package:structogrammar/widgets/structs/instruction_struct.dart';
import 'package:structogrammar/widgets/structs/until_struct.dart';

import '../models/state.dart';

class StructBuilder extends ConsumerWidget {
  StructBuilder({
    super.key,
    required this.struct,
    required this.maxWidth,
    this.dragIndex,
    this.bottomBorder,
    this.noRightBorder,
    this.noLeftBorder,
    this.noTopBorder,
    this.expands,
    this.screenshot,
    this.onPan,
  });

  final Struct struct;
  final int? dragIndex;
  final Function(DragUpdateDetails)? onPan;
  double maxWidth;
  final bool? screenshot;
  final bool? bottomBorder;
  final bool? noRightBorder;
  final bool? noTopBorder;
  final bool? expands;
  final bool? noLeftBorder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedStruct = ref.watch(selectedStructPod);
    var cursor = ref.watch(cursorPod);
    var draggedStruct = ref.watch(dragStructIdPod);
    String? color = struct.data["color"];
    // if (struct.data["size"] != null) {
    //   double? newSize = double.tryParse(struct.data["size"]);
    //   if (newSize != null && newSize > maxWidth) {
    //     maxWidth = newSize;
    //   }
    // }

    return Padding(
        padding: (struct.data["size"] != null)
            ? const EdgeInsets.all(8.0)
            : EdgeInsets.zero,
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          MouseRegion(
            onHover: (details) {
              if (struct.data["size"] == null) return;
              if (details.localPosition.dx > maxWidth - 10 &&
                  details.localPosition.dx < maxWidth + 10) {
                ref.read(cursorPod.notifier).state =
                    SystemMouseCursors.resizeLeftRight;
              } else {
                if (cursor != SystemMouseCursors.basic) {
                  ref.read(cursorPod.notifier).state = SystemMouseCursors.basic;
                }
              }
            },
            onExit: (_) {
              ref.read(cursorPod.notifier).state = SystemMouseCursors.basic;
            },
            child: GestureDetector(

              onTap: () async {
                if (selectedStruct == struct.id) {
                  ref.read(selectedStructPod.notifier).state = "";
                } else {
                  //this throws because other containers below also receive the ontap and try to set the id, but it throws an error because theres already a task in process
                  try {
                    ref.read(selectedStructPod.notifier).state = struct.id;
                  } catch (_) {}
                  //ref.read(selectedStructPod.notifier).state = struct.id;
                  if (ref.read(structsPod.notifier).findRootStruct(struct.id) !=
                      null) {
                    ref.read(codePod.notifier).generate(ref
                        .read(structsPod.notifier)
                        .findRootStruct(struct.id)!);
                  }
                }
              },
              child: ContextMenuRegion(
                onItemSelected: (_) {
                  if (ref.read(structsPod.notifier).findRootStruct(struct.id) !=
                      null)
                    ref.read(codePod.notifier).generate(ref
                        .read(structsPod.notifier)
                        .findRootStruct(struct.id)!);
                },
                contextMenu: getContextMenuForStruct(struct, context, ref),
                child: Container(
                  width: maxWidth,
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                      //border: Border.all(color: Colors.black,width: 1, strokeAlign: BorderSide.strokeAlignCenter),
                      border: Border(
                          left: (draggedStruct == struct.id)
                              ? BorderSide(width: 2, color: Colors.black)
                              : (noLeftBorder == true)
                                  ? BorderSide(
                                      color: Colors.transparent, width: 0)
                                  : BorderSide(width: 2, color: Colors.black),
                          right: (draggedStruct == struct.id)
                              ? BorderSide(width: 2, color: Colors.black)
                              : (noRightBorder == true)
                                  ? BorderSide(
                                      color: Colors.transparent, width: 0)
                                  : BorderSide(width: 2, color: Colors.black),
                          top: (draggedStruct == struct.id)
                              ? BorderSide(width: 2, color: Colors.black)
                              : (noTopBorder == true)
                                  ? BorderSide(
                                      color: Colors.transparent, width: 0)
                                  : BorderSide(width: 2, color: Colors.black),
                          bottom: (draggedStruct == struct.id ||
                                  screenshot == true)
                              ? BorderSide(width: 2, color: Colors.black)
                              : (bottomBorder == true)
                                  ? BorderSide(width: 2, color: Colors.black)
                                  : BorderSide(
                                      width: 0, color: Colors.transparent)),
                      color: (selectedStruct == struct.id && screenshot == null)
                          ? Colors.blue[200]
                          : (color != null)
                              ? HexColor(color)
                              : Colors.white),
                  child: IntrinsicHeight(
                    child: SizedBox(
                      width: maxWidth,
                      child: Column(
                        children: [
                          Builder(builder: (context) {
                            switch (struct.type) {
                              case StructType.function:
                                return FunctionStructWidget(
                                  struct: struct,
                                  maxWidth: maxWidth,
                                );
                              case StructType.ifSelect:
                                return IFStructWidget(
                                    struct: struct, maxWidth: maxWidth);
                              case StructType.caseSelect:
                                return CaseStructWidget(
                                    struct: struct, maxWidth: maxWidth);
                              case StructType.instruction:
                                return InstructionStructWidget(
                                    struct: struct, maxWidth: maxWidth);
                              case StructType.loop:
                                return ForStructWidget(
                                    struct: struct, maxWidth: maxWidth);
                              case StructType.repeat:
                                return UntilStructWidget(
                                    struct: struct, maxWidth: maxWidth);
                              default:
                                return InstructionStructWidget(
                                    struct: struct, maxWidth: maxWidth);
                            }
                          }),
                          SizedBox()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ]));
  }
}

TextStyle functionTextStyle = TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold);
TextStyle commentTextStyle = TextStyle(color: Colors.grey, fontSize: 12);
TextStyle textStyleFromMap(Map<String, dynamic> data, String prefix, {TextStyle? style}) {
  style ??= TextStyle();
  FontWeight weight = FontWeight.w400;
  switch (data["${prefix}Weight"]) {
    case "medium":
      weight = FontWeight.w500;
    case "semibold":
      weight = FontWeight.w500;
    case "bold":
      weight = FontWeight.w700;
    case "extrabold":
      weight = FontWeight.w800;
  }
  return style.copyWith(
    fontSize: double.tryParse(data["${prefix}Size"].toString()),
    color: data["${prefix}Color"] != null? HexColor(data["${prefix}Color"]): null,
  );
}
