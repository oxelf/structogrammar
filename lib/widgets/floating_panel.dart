import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/riverpod/state.dart';

class FloatingPanel extends ConsumerStatefulWidget {
  FloatingPanel({super.key, required this.child, required this.pod, this.left});

  final Widget child;
  final StateProvider<double> pod;
  final bool? left;

  @override
  FloatingPanelState createState() => FloatingPanelState();
}

class FloatingPanelState extends ConsumerState<FloatingPanel> {
  double minWidth = 225;
  double? resizeWidth;

  @override
  Widget build(BuildContext context) {
    var width = ref.watch(widget.pod);
    width = resizeWidth ?? width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onHorizontalDragStart: (details) {
          if (widget.left == true) {
            if (details.localPosition.dx < (resizeWidth ?? width) + 10 &&
                details.localPosition.dx > (resizeWidth ?? width) - 10) {
              ref.read(cursorPod.notifier).state =
                  SystemMouseCursors.resizeLeftRight;
              resizeWidth = width;
            }
            return;
          }
          if (details.localPosition.dx < 10 && details.localPosition.dx > -10) {
            ref.read(cursorPod.notifier).state =
                SystemMouseCursors.resizeLeftRight;
            resizeWidth = width;
          }
        },
        onHorizontalDragUpdate: (details) {
          if (resizeWidth == null) return;
          double newWidth = resizeWidth! - details.delta.dx;
          if (widget.left == true) {
            newWidth = resizeWidth! + details.delta.dx;
          }
          if (newWidth < minWidth) return;
          setState(() {
            resizeWidth = newWidth;
          });
          ref.read(widget.pod.notifier).state = newWidth;
        },
        onHorizontalDragEnd: (_) {
          ref.read(cursorPod.notifier).state = SystemMouseCursors.basic;
        },
        onHorizontalDragCancel: () {
          resizeWidth = null;
          ref.read(cursorPod.notifier).state = SystemMouseCursors.basic;
        },
        child: Container(
          height: MediaQuery.sizeOf(context).height - 16,
          width: resizeWidth ?? width,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  blurRadius: 10,
                  color: Colors.black.withOpacity(0.3),
                  offset: Offset(-5, 0))
            ],
          ),
          child: Stack(
            children: [
              widget.child,
              (widget.left == true)
                  ? Positioned(
                      right: 0,
                      child: MouseRegion(
                          cursor: SystemMouseCursors.resizeLeftRight,
                          child: Container(
                            width: 15,
                            height: MediaQuery.sizeOf(context).height,
                          )))
                  : Positioned(
                      left: 0,
                      child: MouseRegion(
                          cursor: SystemMouseCursors.resizeLeftRight,
                          child: Container(
                            width: 15,
                            height: MediaQuery.sizeOf(context).height,
                          ))),
            ],
          ),
        ),
      ),
    );
  }
}
