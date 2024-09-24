import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/managers/structs_manager.dart';
import 'package:structogrammar/models/struct.dart';
import 'package:structogrammar/riverpod/structs.dart';
import 'package:structogrammar/util/app_colors.dart';
import 'package:structogrammar/util/struct_context_menu.dart';
import 'package:structogrammar/widgets/struct/structs/do_while_struct.dart';
import 'package:structogrammar/widgets/struct/structs/for_struct.dart';
import 'package:structogrammar/widgets/struct/structs/function_struct.dart';
import 'package:structogrammar/widgets/struct/structs/if_struct.dart';
import 'package:structogrammar/widgets/struct/structs/instruction_struct.dart';
import 'package:structogrammar/widgets/struct/structs/try_struct.dart';
import 'package:super_context_menu/super_context_menu.dart';

import '../../riverpod/managers.dart';

enum StructBorder { left, bottom, right, top }

class StructWidget extends ConsumerStatefulWidget {
  StructWidget({
    super.key,
    required this.struct,
    this.borders = const [],
    this.width,
  });

  final Struct struct;
  final List<StructBorder> borders;
  final double? width;

  @override
  StructWidgetState createState() => StructWidgetState();
}

class StructWidgetState extends ConsumerState<StructWidget> {
  double? resizeWidth;
  BorderSide border = BorderSide(color: Colors.grey, width: 1);
  BorderSide emptyBorder = BorderSide(color: Colors.transparent, width: 0);

  @override
  Widget build(BuildContext context) {
    var selected = ref.watch(selectedStructPod) == widget.struct.id;
    double width = resizeWidth ?? widget.struct.width ?? widget.width ?? 400;
    return Stack(
      children: [
        ContextMenuWidget(
          menuProvider: (r) =>
              getStructContextMenu(r, widget.struct, context, ref),
          child: GestureDetector(
            onTap: () {
              ref.read(selectedStructPod.notifier).state = widget.struct.id;
            },
            child: Container(
              padding: EdgeInsets.zero,
              width: width,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : Colors.white,
                borderRadius: widget.struct.type == StructType.function
                    ? BorderRadius.circular(8)
                    : null,
                border: Border(
                  bottom: (widget.borders.contains(StructBorder.bottom))
                      ? border
                      : emptyBorder,
                  top: (widget.borders.contains(StructBorder.top))
                      ? border
                      : emptyBorder,
                  left: (widget.borders.contains(StructBorder.left))
                      ? border
                      : emptyBorder,
                  right: (widget.borders.contains(StructBorder.right))
                      ? border
                      : emptyBorder,
                ),
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Builder(
                      builder: (context) {
                        double newWidth = width - additionalBorderSpace();
                        switch (widget.struct.type) {
                          case StructType.function:
                            return FunctionStruct(
                                struct: widget.struct, width: newWidth);
                          case StructType.forLoop:
                            return ForStruct(
                                struct: widget.struct, width: newWidth);
                          case StructType.whileLoop:
                            return ForStruct(
                                struct: widget.struct, width: newWidth);
                          case StructType.doWhileLoop:
                            return DoWhileStruct(
                                struct: widget.struct, width: newWidth);
                          case StructType.ifStatement:
                            return IfStruct(
                                struct: widget.struct, width: newWidth);
                          case StructType.tryStatement:
                            return TryStruct(
                                struct: widget.struct, width: newWidth);
                          default:
                            return InstructionStruct(
                                struct: widget.struct, width: newWidth);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (widget.struct.type == StructType.function)
          Positioned(
              right: 0,
              bottom: 0,
              top: 0,
              child: GestureDetector(
                onHorizontalDragEnd: (_) async {
                  StructsManager mgr = await ref.read(structManagerPod.future);
                  mgr.resizeStruct(
                      widget.struct.id ?? -1, resizeWidth ?? width);
                  Future.delayed(Duration(milliseconds: 25), () {
                    if (mounted) setState(() {
                      resizeWidth = null;
                    });
                  });
                },
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    resizeWidth ??= width;
                    resizeWidth = resizeWidth! + details.delta.dx;
                  });

                  //print("resize: ${details.delta.dx}");
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeLeftRight,
                  child: Container(
                    width: 5,
                  ),
                ),
              )),
      ],
    );
  }

  additionalBorderSpace() {
    return (widget.borders.contains(StructBorder.left) ? 1 : 0) +
        (widget.borders.contains(StructBorder.right) ? 1 : 0);
  }
}
