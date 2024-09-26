import 'package:flutter/material.dart';
import 'package:structogrammar/models/tab.dart';
import 'package:structogrammar/util/app_colors.dart';

class SAppBarTab extends StatefulWidget {
  const SAppBarTab({
    super.key,
    required this.height,
    required this.tab,
    required this.tabName,
    required this.selected,
    required this.onTap,
    this.leftBorder = false,
    this.onClosed,
  });

  final double height;
  final STab tab;
  final String tabName;
  final bool selected;
  final bool leftBorder;
  final Function() onTap;
  final Function()? onClosed;

  @override
  State<SAppBarTab> createState() => _SAppBarTabState();
}

class _SAppBarTabState extends State<SAppBarTab> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
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
          widget.onTap.call();
        },
        child: Container(
          height: widget.height,
          decoration: BoxDecoration(
            color:
                widget.selected || hovered ? AppColors.editorBackground : null,
            border: Border(
              right: BorderSide(color: AppColors.borderColor),
              left: widget.leftBorder
                  ? BorderSide(color: AppColors.borderColor)
                  : const BorderSide(color: Colors.transparent),
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 8.0, top: 4, bottom: 4, right: 2),
            child: Row(
              children: [
                widget.tab.icon,
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.tabName),
                    ],
                  ),
                ),
                if (widget.tab.closable)
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints:
                            const BoxConstraints(maxHeight: 30, maxWidth: 30),
                        onPressed: () {
                          widget.onClosed?.call();
                        },
                        icon: const Icon(
                          Icons.close,
                          size: 18,
                        )),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
