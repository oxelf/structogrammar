import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/context_extension.dart';
import 'package:structogrammar/managers/projects_manager.dart';
import 'package:structogrammar/models/struct.dart';
import 'package:structogrammar/pages/struct_editor/hierarchy.dart';
import 'package:structogrammar/pages/struct_editor/struct_shortcuts.dart';
import 'package:structogrammar/riverpod/managers.dart';
import 'package:structogrammar/riverpod/state.dart';
import 'package:structogrammar/util/screenshot.dart';
import 'package:structogrammar/widgets/canvas/canvas.dart';
import 'package:structogrammar/widgets/canvas/controller.dart';
import 'package:structogrammar/widgets/panel/panel.dart';
import 'package:structogrammar/widgets/struct/struct_widget.dart';

import '../../riverpod/structs.dart';

class StructEditor extends ConsumerStatefulWidget {
  const StructEditor({
    super.key,
    required this.struct,
    required this.projectId,
  });

  final Struct struct;
  final int projectId;

  @override
  ConsumerState createState() => _StructEditorState();
}

class _StructEditorState extends ConsumerState<StructEditor> {
  CanvasController canvasController =
      CanvasController(startCoordinates: const Offset(4700, 5000));

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 10), () {
        canvasController.zoomToFit(context.width, context.height - 50, 0,
            padding: const Offset(550, 32));
      });
      Timer.periodic(const Duration(seconds: 30), (t) async {
        if (!mounted) t.cancel();
        Uint8List? bytes =
            await screenshotWidget(StructWidget(struct: widget.struct));
        if (bytes != null) {
          String encodedImage = base64Encode(bytes.toList());
          if (!mounted) {
            t.cancel();
            return;
          }
          ProjectManager mgr = await ref.read(projectsManagerPod.future);
          mgr.updateProjectImage(widget.projectId, encodedImage);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var selectedStruct = ref.watch(selectedStructPod);
    return Stack(
      children: [
        StructShortcutsWidget(
          onZoomToFit: () {
            canvasController.zoomToFit(context.width, context.height - 50, 0,
                padding: const Offset(564, 32));
          },
          child: InfiniteCanvas(controller: canvasController, items: [
            CanvasItem(
                x: 5000,
                y: 5000,
                child: StructWidget(
                  struct: widget.struct,
                  borders: const [
                    StructBorder.left,
                    StructBorder.top,
                    StructBorder.bottom,
                    StructBorder.right
                  ],
                )),
          ]),
        ),
        const StructHierarchy(),
        Positioned(
          right: 0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SidePanel(
              widthPod: structEditSidePanelPod,
              content: const Text("content"),
              header: const Text(
                "Edit",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
