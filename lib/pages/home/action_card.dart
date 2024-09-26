import 'package:flutter/material.dart';

import '../../util/app_colors.dart';

class ActionCard extends StatefulWidget {
  const ActionCard({
    super.key,
    required this.onTap,
    required this.title,
    required this.subTitle,
    required this.color,
    required this.icon,
  });

  final Function() onTap;
  final String title;
  final String subTitle;
  final Color color;
  final Widget icon;

  @override
  State<ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<ActionCard> {
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
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: hovered ? widget.color : AppColors.editorBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          width: 250,
          height: 80,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: hovered ? darken(widget.color, 0.3) : widget.color,
                  ),
                  child: widget.icon,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(),
                  Text(
                    widget.title,
                    style: TextStyle(color: hovered ? Colors.white : null, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.subTitle,
                    style: TextStyle(color: hovered ? Colors.white : null, fontSize: 12),
                  ),
                  const SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
