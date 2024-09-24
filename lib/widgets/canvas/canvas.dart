import 'package:flutter/material.dart';
import 'package:structogrammar/widgets/canvas/controller.dart';
import 'package:structogrammar/widgets/canvas/drag_handles.dart';
import 'package:universal_html/html.dart' as html;

class CanvasItem {
  double x;
  double y;
  Widget child;

  CanvasItem({required this.x, required this.y, required this.child});
}

class InfiniteCanvas extends StatefulWidget {
  const InfiniteCanvas({
    super.key,
    required this.items,
    required this.controller,
  });

  final CanvasController controller;
  final List<CanvasItem> items;

  @override
  State<InfiniteCanvas> createState() => _InfiniteCanvasState();
}

class _InfiniteCanvasState extends State<InfiniteCanvas> {
  @override
  void initState() {
    html.document.onContextMenu.listen((event) => event.preventDefault());
    widget.controller.items = widget.items;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant InfiniteCanvas oldWidget) {
    widget.controller.items = widget.items;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Matrix4>(
      valueListenable: widget.controller.transformationNotifier,
      builder: (context, matrix, child) {
        return Stack(
          children: [
            InteractiveViewer(
              transformationController:
                  widget.controller.transformationController,
              boundaryMargin: EdgeInsets.all(double.infinity),
              minScale: 0.1,
              maxScale: 10,
              constrained: false,
              onInteractionUpdate: (details) {
                widget.controller.onInteractionUpdate(details);
                setState(() {});
              },
              child: Container(
                color: Colors.grey.shade200,
                width: 10000,
                height: 10000,
                child: Stack(
                  children: [
                    for (int i = 0; i < widget.items.length; i++)
                      Builder(builder: (context) {
                        GlobalKey newKey = GlobalKey();
                        widget.controller.keys[i] = newKey;
                        return Positioned(
                          key: newKey,
                          left: widget.items[i].x,
                          top: widget.items[i].y,
                          child:  widget.items[i].child,
                        );
                      }),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 16,
              bottom: 8,
              child: InkWell(
                onTap: () {
                  // Your onTap code
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  width: 50,
                  height: 30,
                  child: Center(
                    child:
                        Text("${(matrix.getMaxScaleOnAxis() * 100).toInt()}%"),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
