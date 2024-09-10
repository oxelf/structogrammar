import 'dart:math';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/models/struct.dart';
import 'package:structogrammar/pages/main/edit_panel.dart';
import 'package:structogrammar/riverpod/hierarchy.dart';
import 'package:structogrammar/riverpod/state.dart';
import 'package:structogrammar/riverpod/structs.dart';
import 'package:structogrammar/widgets/conditional_dotted_border.dart';

class HierachySubWidget extends ConsumerStatefulWidget {
  const HierachySubWidget(
      {super.key,
      required this.struct,
      required this.offset,
      required this.connectToTop,
      required this.connnectToBottom});

  final Struct struct;
  final double offset;
  final bool connectToTop;
  final bool connnectToBottom;

  @override
  ConsumerState createState() => _HierachySubWidgetState();
}

class _HierachySubWidgetState extends ConsumerState<HierachySubWidget> {
  bool hovered = false;
  GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var selectedStruct = ref.watch(selectedStructPod);
    var hierarchy = ref.watch(hierarchyPod);
    var width = ref.watch(leftFloatingPanelWidthPod);
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    var dragPos = ref.watch(hierarchyDragPositionPod);
    bool dragBelow = false;
    bool dragInside = false;
    if (dragPos != null && box != null) {
      double bottomBorderY = box.localToGlobal(Offset(0, box.size.height)).dy;
      double topBorderY = box.localToGlobal(Offset(0, 0)).dy;
      if (dragPos.dy < bottomBorderY + 10 && dragPos.dy > bottomBorderY - 10) {
        Future.delayed(Duration(milliseconds: 10), () {
          if (hierarchy[widget.struct.id] == true ||
              (widget.struct.type == StructType.instruction &&
                  widget.struct.type != StructType.function)) {
            ref.read(hierarchyDragTargetLocationPod.notifier).state =
                ("after", widget.struct.id);
          } else {
            ref.read(hierarchyDragTargetLocationPod.notifier).state =
                ("inside", widget.struct.id);
          }
        });

        dragBelow = true;
      } else if (dragPos.dy < bottomBorderY - 10 &&
          dragPos.dy > topBorderY + 10 &&
          widget.struct.type != StructType.instruction) {
        Future.delayed(Duration(milliseconds: 10), () {
          ref.read(hierarchyDragTargetLocationPod.notifier).state =
              ("inside", widget.struct.id);
        });
        dragInside = true;
      }
    }
    Widget getChild(bool feedback) {
      return Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 0, right: 2),
              child: MouseRegion(
                onHover: (_) {
                  setState(() {
                    hovered = true;
                  });
                },
                onExit: (_) {
                  setState(() {
                    hovered = false;
                  });
                },
                child: GestureDetector(
                  onTap: () {
                    ref.read(selectedStructPod.notifier).state =
                        widget.struct.id;
                  },
                  child: ConditionalDottedBorder(
                    dotted: dragInside,
                    child: Container(
                      key: (feedback) ? null : key,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: (selectedStruct == widget.struct.id)
                            ? Colors.blue[200]
                            : hovered
                                ? Color.fromRGBO(245, 245, 245, 1)
                                : null,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: widget.offset,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 2,
                                color: (widget.connectToTop)
                                    ? Colors.black
                                    : Colors.transparent,
                                height: 15,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Container(
                                  width: 10,
                                  height: 2,
                                  color: (widget.connnectToBottom ||
                                          widget.connectToTop)
                                      ? Colors.black
                                      : Colors.transparent,
                                ),
                              ),
                              Container(
                                width: 2,
                                color: (widget.connnectToBottom)
                                    ? Colors.black
                                    : Colors.transparent,
                                height: 15,
                              ),
                            ],
                          ),
                          if (widget.struct.subStructs.isNotEmpty)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 2,
                                  color: Colors.transparent,
                                  height: 7,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(hierarchyPod.notifier)
                                        .click(widget.struct.id);
                                    setState(() {});
                                  },
                                  child: Transform.rotate(
                                    angle: (hierarchy[widget.struct.id] == true)
                                        ? -pi / 2
                                        : 0,
                                    child: Icon(
                                      Icons.arrow_drop_down_circle_outlined,
                                      size: 16,
                                    ),
                                  ),
                                ),
                                if ((hierarchy[widget.struct.id] == false ||
                                        hierarchy[widget.struct.id] == null) &&
                                    widget.struct.subStructs.isNotEmpty)
                                  Container(
                                    width: 2,
                                    color: Colors.black,
                                    height: 10,
                                  ),
                              ],
                            ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 8,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Icon(
                                  getIcon(widget.struct.type),
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Text(translateStructType(
                                  context, widget.struct.type)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (dragBelow)
              Divider(
                color: Colors.blue[400],
              ),
            Builder(builder: (context) {
              bool show = (hierarchy[widget.struct.id] == false ||
                  hierarchy[widget.struct.id] == null);
              return (!show)
                  ? SizedBox()
                  : Column(
                      children: [
                        for (int i = 0;
                            i < widget.struct.subStructs.length;
                            i++)
                          HierachySubWidget(
                            struct: widget.struct.subStructs[i],
                            offset: widget.offset + 17,
                            connnectToBottom:
                                (i + 1 != widget.struct.subStructs.length),
                            connectToTop: true,
                          ),
                      ],
                    );
            }),
          ],
        ),
      );
    }

    return (widget.struct.type == StructType.function)
        ? getChild(false)
        : Draggable(
            child: getChild(false),
            onDragUpdate: (details) {
              ref.read(hierarchyDragPositionPod.notifier).state =
                  details.globalPosition;
            },
            onDragCompleted: () {
              ref.read(hierarchyDragPositionPod.notifier).state = null;
              ref.read(hierarchyDragTargetLocationPod.notifier).state = null;
            },
            onDragEnd: (_) {
              var data = ref.read(hierarchyDragTargetLocationPod);
              if (data?.$2 == widget.struct.id) {
                ref.read(hierarchyDragPositionPod.notifier).state = null;
                ref.read(hierarchyDragTargetLocationPod.notifier).state = null;
                return;
              }
              if (data?.$1 == "after") {
                ref.read(structsPod.notifier).removeStruct(widget.struct.id);
                ref
                    .read(structsPod.notifier)
                    .addStructAfter(data?.$2 ?? "", widget.struct);
              } else if (data?.$1 == "inside") {
                ref.read(structsPod.notifier).removeStruct(widget.struct.id);
                ref
                    .read(structsPod.notifier)
                    .addSubStruct(data?.$2 ?? "", widget.struct);
              }
              ref.read(hierarchyDragPositionPod.notifier).state = null;
              ref.read(hierarchyDragTargetLocationPod.notifier).state = null;
            },
            onDraggableCanceled: (v, o) {
              ref.read(hierarchyDragPositionPod.notifier).state = null;
              ref.read(hierarchyDragTargetLocationPod.notifier).state = null;
            },
            feedback:
                Material(child: SizedBox(width: width, child: getChild(true))),
          );
  }

  IconData getIcon(StructType type) {
    switch (type) {
      case StructType.function:
        return CommunityMaterialIcons.code_braces;
      case StructType.instruction:
        return CommunityMaterialIcons.code_tags;
      case StructType.loop:
        return Icons.loop;
      case StructType.repeat:
        return Icons.loop;
      case StructType.ifSelect:
        return CommunityMaterialIcons.code_parentheses;
      case StructType.caseSelect:
        return CommunityMaterialIcons.code_parentheses;
      default:
        return Icons.text_fields_sharp;
    }
  }
}
