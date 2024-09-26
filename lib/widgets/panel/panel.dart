import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/context_extension.dart';

class SidePanel extends ConsumerStatefulWidget {
  const SidePanel({
    super.key,
    required this.widthPod,
    required this.content,
    this.minWidth = 250,
    this.color = Colors.white,
    this.canExpand = true,
    this.header = const SizedBox(),
    this.left = false,
  });

  final StateProvider<double> widthPod;
  final double minWidth;
  final Color color;
  final bool canExpand;
  final Widget content;
  final Widget header;
  final bool left;

  @override
  ConsumerState createState() => _SidePanelState();
}

class _SidePanelState extends ConsumerState<SidePanel> {
  bool expanded = true;
  double? resizeWidth;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var podWidth = ref.watch(widget.widthPod);
    double width = resizeWidth ?? podWidth;
    return Container(
      width: width,
      height: (expanded) ? context.height - 70 : 60,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.header,
                    if (widget.canExpand)
                      IconButton(
                          tooltip: (expanded) ? "Collapse" : "Expand",
                          onPressed: () {
                            setState(() {
                              expanded = !expanded;
                            });
                          },
                          padding: EdgeInsets.zero,
                          icon: const Icon(CupertinoIcons.sidebar_right)),
                  ],
                ),
              ),
              if (expanded) const Divider(),
              if (expanded) widget.content,
            ],
          ),
          Positioned(
              left: (widget.left == true) ? null : 0,
              right: (widget.left == true) ? 0 : null,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () {
                  print("test");
                },
                onHorizontalDragDown: (_) {
                  if (resizeWidth == null) return;
                  Future.delayed(const Duration(milliseconds: 25), () {
                    ref.read(widget.widthPod.notifier).state = resizeWidth!;
                    resizeWidth = null;
                  });
                },
                onHorizontalDragCancel: () {
                  if (resizeWidth == null) return;
                  Future.delayed(const Duration(milliseconds: 25), () {
                    ref.read(widget.widthPod.notifier).state = resizeWidth!;
                    resizeWidth = null;
                  });
                },
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    resizeWidth ??= width;
                    resizeWidth = resizeWidth! + ((!widget.left)? - details.delta.dx:  details.delta.dx);
                   if (resizeWidth! < widget.minWidth) resizeWidth = widget.minWidth;
                  });
               // ref.read(widget.widthPod.notifier).state = newWidth;
              },
                onHorizontalDragEnd: (_) {
                  if (resizeWidth == null) return;
                  Future.delayed(const Duration(milliseconds: 25), () {
                    ref.read(widget.widthPod.notifier).state = resizeWidth!;
                    resizeWidth = null;
                  });
                },
                child: MouseRegion(
                    cursor: SystemMouseCursors.resizeLeftRight,
                    child: Container(
                      width: 10,
                    )),
              )),
        ],
      ),
    );
  }
}
