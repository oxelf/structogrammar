import 'package:flutter/material.dart';
import 'package:structogrammar/widgets/canvas/canvas.dart';

class CanvasController {
  Map<int, GlobalKey> keys = {};
  double currentScale = 1;
  List<CanvasItem> items = [];
  final TransformationController _transformationController = TransformationController();
  final ValueNotifier<Matrix4> transformationNotifier = ValueNotifier<Matrix4>(Matrix4.identity());

  TransformationController get transformationController => _transformationController;

  void onInteractionUpdate(ScaleUpdateDetails details) {
    currentScale = _transformationController.value.getMaxScaleOnAxis();
    transformationNotifier.value = _transformationController.value;
  }

  void zoomToFit(double width, double height, int index, {Offset padding = const Offset(32, 32)}) {
    GlobalKey? key = keys[index];
    if (key == null) return;
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    double heightZoomFactor = (height - padding.dy) / box.size.height;
    double widthZoomFactor = (width - padding.dx) / box.size.width;

    double zoomFactor = 1;
    if (heightZoomFactor < widthZoomFactor) {
      zoomFactor = heightZoomFactor;
    } else {
      zoomFactor = widthZoomFactor;
    }

    CanvasItem item = items[index];

    double x = item.x * zoomFactor;
    double y = item.y * zoomFactor;

    x -= padding.dx / 2;
    y -= padding.dy / 2;

    jumpToCoordinate(x, y, scale: zoomFactor);
  }

  void zoom(double scale) {
    var translation = _transformationController.value.getTranslation();
    Matrix4 zoomMatrix = _transformationController.value.clone();
    zoomMatrix.scale(scale);
    zoomMatrix.setTranslation(translation);
    _transformationController.value = zoomMatrix;
    transformationNotifier.value = zoomMatrix; // Notify listeners
    currentScale = scale;
  }

  void jumpToCoordinate(double x, double y, {double? scale}) {
    Matrix4 translationMatrix = Matrix4.identity()..translate(-x, -y);

    if (scale != null) {
      translationMatrix.scale(scale);
    } else {
      translationMatrix
          .scale(_transformationController.value.getMaxScaleOnAxis());
    }

    _transformationController.value = translationMatrix;
    transformationNotifier.value = translationMatrix; // Notify listeners
  }

  CanvasController({Offset? startCoordinates}) {
    if (startCoordinates != null)jumpToCoordinate(startCoordinates.dx, startCoordinates.dy);
  }
}