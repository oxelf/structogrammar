import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/main.dart';
import 'package:structogrammar/managers/structs_manager.dart';
import 'package:structogrammar/riverpod/structs.dart';
import 'package:structogrammar/util/app_colors.dart';

import '../../models/struct.dart';

List<StructType?> nonDraggableStructTypes = [
  StructType.caseStatement,
  StructType.catchStatement,
  StructType.ifCondition,
  StructType.function,
];

class HierarchyTileData {
  HierarchyTileData({
    this.collapsable = false,
    this.connectToBottom = false,
    required this.title,
    this.icon,
    this.value,
    this.children = const [],
    this.onTap,
    this.structType,
  });

  final bool collapsable;
  final bool connectToBottom;
  final String title;
  final Widget? icon;
  final dynamic value;
  final StructType? structType;
  final List<HierarchyTileData> children;
  final Function(dynamic)? onTap;
}

class HierarchyTile extends ConsumerStatefulWidget {
  const HierarchyTile({
    super.key,
    required this.data,
    this.offset = 0,
  });

  final HierarchyTileData data;
  final double offset;

  @override
  HierarchyTileState createState() => HierarchyTileState();
}

class HierarchyTileState extends ConsumerState<HierarchyTile>
    with AutomaticKeepAliveClientMixin {
  bool expanded = true;
  GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var selectedStruct = ref.watch(selectedStructPod);
    bool selected = (selectedStruct == widget.data.value);
    bool dragBelow = false;
    Offset? globalDragCoordinates = ref.watch(structDragCoordinatesPod);
    if (globalDragCoordinates != null) {
      RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
      if (box != null) {
        Offset local = box.globalToLocal(globalDragCoordinates);
        if (local.dy > box.size.height - 15 &&
            local.dy < box.size.height + 15) {
          dragBelow = true;
          StructDragLocation location = StructDragLocation.after;
          int dragTargetId = widget.data.value;
          if (widget.data.children.isNotEmpty && expanded) {
            location = StructDragLocation.before;
            dragTargetId = widget.data.children.first.value;
          }
          Future.delayed(Duration(milliseconds: 10), () {
            ref.read(structDragTargetLocationPod.notifier).state =
                (dragTargetId, location);
          });
        }
      }
    }
    Widget getHierarchyTile(bool drag) {
      return LayoutBuilder(builder: (context, constraints) {
        return Container(
          // width: (drag)?250: null,
          // height: 30,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () {
                    widget.data.onTap?.call(widget.data.value);
                  },
                  child: Container(
                    key: (drag) ? null : key,
                    width: constraints.maxWidth - 8,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                          bottomLeft:
                              (widget.data.children.isEmpty || !expanded)
                                  ? Radius.circular(6)
                                  : Radius.zero,
                          bottomRight:
                              (widget.data.children.isEmpty || !expanded)
                                  ? Radius.circular(6)
                                  : Radius.zero),
                      color:
                          (selected) ? AppColors.primary : Colors.transparent,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: (widget.offset > 80) ? 80 : widget.offset,
                        ),
                        (widget.data.children.isNotEmpty)
                            ? SizedBox(
                                width: 20,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      expanded = !expanded;
                                    });
                                  },
                                  child: Icon(
                                    Icons.arrow_drop_down_circle_outlined,
                                    size: 14,
                                  ),
                                ))
                            : const SizedBox(
                                width: 20,
                              ),
                        (widget.data.icon != null)
                            ? SizedBox(width: 20, child: widget.data.icon!)
                            : const SizedBox(
                                width: 20,
                              ),
                        const SizedBox(
                          width: 8,
                        ),
                        SizedBox(
                            width: ((constraints.maxWidth -
                                (widget.offset > 60 ? 60 : widget.offset) - 60) < 0)?0: constraints.maxWidth -
                                (widget.offset > 60 ? 60 : widget.offset) - 60,
                            child: Text(
                              widget.data.title,
                              overflow: TextOverflow.ellipsis,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              if (!drag && dragBelow) Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  decoration: BoxDecoration(
                    color: (selectedStruct == widget.data.value)
                        ? AppColors.primary.withAlpha(200)
                        : Colors.transparent,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(6),
                      bottomRight: Radius.circular(6),
                    ),
                  ),
                  child: Column(
                    children: [
                      if (expanded)
                        for (var child in widget.data.children)
                          HierarchyTile(
                            data: child,
                            offset: widget.offset + 8,
                          ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      });
    }

    ;
    return Draggable(
      feedback:
          Material(child: SizedBox(width: 250, child: getHierarchyTile(true))),
      child: getHierarchyTile(false),
      onDragStarted: () {
        setState(() {
          expanded = false;
        });
      },
      onDragEnd: (details) {
        ref.read(structDragCoordinatesPod.notifier).state = null;
        var data = ref.read(structDragTargetLocationPod);
        if (data == null) return;
        int id = data.$1;
        StructDragLocation location = data.$2;
        globalStructManager.moveStruct(widget.data.value, id, location);
      },
      onDragCompleted: () async {
        ref.read(structDragCoordinatesPod.notifier).state = null;
        // var data = ref.read(structDragTargetLocationPod);
        // if (data == null) return;
        // int id = data.$1;
        // StructDragLocation location = data.$2;
        // globalStructManager.moveStruct(widget.data.value, id, location);
      },
      onDragUpdate: (details) {
        ref.read(structDragCoordinatesPod.notifier).state =
            details.globalPosition;
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
