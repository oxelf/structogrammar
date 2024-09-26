import 'package:flutter/material.dart';
import 'package:structogrammar/util/app_colors.dart';

class DragHandles extends StatefulWidget {
  const DragHandles({
    super.key,
    required this.child,
    required this.showHandles,
    this.onHorizontalResize,
  });

  final Widget child;
  final bool showHandles;
  final Function(double delta)? onHorizontalResize;

  @override
  State<DragHandles> createState() => _DragHandlesState();
}

class _DragHandlesState extends State<DragHandles> {
  final double _initialHorizontalPosition = 0.0;
  double _currentHorizontalPosition = 0.0;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _currentHorizontalPosition += details.delta.dx;
      if (widget.onHorizontalResize != null) {
        widget.onHorizontalResize!(details.delta.dx);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: widget.child,
        ),
        if (widget.showHandles) ...[
          Positioned(
            top: 0,
            left: 8,
            right: 8,
            child: Divider(
              color: AppColors.primary,
              thickness: 2,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 8,
            right: 8,
            child: Divider(
              color: AppColors.primary,
              thickness: 2,
            ),
          ),
          Positioned(
            top: 8,
            bottom: 8,
            left: 0,
            child: VerticalDivider(
              color: AppColors.primary,
              thickness: 2,
            ),
          ),
          Positioned(
            top: 8,
            bottom: 8,
            right: 0,
            child: VerticalDivider(
              color: AppColors.primary,
              thickness: 2,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: GestureDetector(
              onHorizontalDragUpdate: _onHorizontalDragUpdate,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.editorBackground,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onHorizontalDragUpdate: _onHorizontalDragUpdate,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.editorBackground,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: GestureDetector(
              onHorizontalDragUpdate: _onHorizontalDragUpdate,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.editorBackground,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onHorizontalDragUpdate: _onHorizontalDragUpdate,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.editorBackground,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}