import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/models/struct.dart';
import 'package:structogrammar/riverpod/state.dart';
import 'package:structogrammar/riverpod/structs.dart';
import 'package:structogrammar/riverpod/translation.dart';
import 'package:structogrammar/widgets/struct_builder.dart';
import 'package:universal_html/html.dart' as html;

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key, required this.height});
  final double height;
  @override
  MainViewState createState() => MainViewState();
}

class MainViewState extends ConsumerState<MainView> {
  final TransformationController _transformationController =
      TransformationController();
  double _currentScale = 1.0;
  double offset = 0.0;
  Map<String, GlobalKey> structKeys = {};
  double? resizeWidth;

  @override
  void initState() {
    html.document.onContextMenu.listen((event) => event.preventDefault());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var rightPanelWidth = ref.read(rightFloatingPanelWidthPod);
      var leftPanelWidth = ref.read(leftFloatingPanelWidthPod);
      var width = MediaQuery.sizeOf(context).width - rightPanelWidth - 20 - leftPanelWidth;
      var selectedStructId = ref.read(selectedStructPod);
      zoomToFit(width, leftPanelWidth);
    });
    super.initState();
  }

  void zoomCanvas(double scaleFactor) {
    setState(() {
      _currentScale *= scaleFactor;
      _transformationController.value = Matrix4.identity()
        ..scale(_currentScale);
    });
  }

  void setExactZoom(double scale) {
    // Create a new matrix with the exact scale you want
    Matrix4 zoomMatrix = Matrix4.identity()
      ..scale(scale);

    setState(() {
      _transformationController.value = zoomMatrix;
      _currentScale = scale;
    });
  }

  // Called whenever the user zooms with pinch/scroll gestures
  void _onInteractionUpdate(ScaleUpdateDetails details) {
    setState(() {
      _currentScale = _transformationController.value.getMaxScaleOnAxis();
    });
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    setState(() {
      _transformationController.value = _transformationController.value
        ..translate(details.delta.dx, details.delta.dy);
    });
  }

  void jumpToCoordinate(double x, double y, {double? scale}) {
    // Create a new matrix with the given translation (x, y)
    Matrix4 translationMatrix = Matrix4.identity()
      ..translate(-x, -y);

    if (scale != null) {
      // Optionally apply a zoom level if provided
      translationMatrix.scale(scale);
    } else {
      // Keep the existing zoom level from the current transformation
      translationMatrix.scale(_transformationController.value.getMaxScaleOnAxis());
    }

    setState(() {
      _transformationController.value = translationMatrix;
    });
  }



  @override
  Widget build(BuildContext context) {
    var structs = ref.watch(structsPod);
    var cursor = ref.watch(cursorPod);
    var translations = ref.watch(translationsPod);
    var rightPanelWidth = ref.watch(rightFloatingPanelWidthPod);
    var leftPanelWidth = ref.watch(leftFloatingPanelWidthPod);
    var width = MediaQuery.sizeOf(context).width - rightPanelWidth - 20 - leftPanelWidth;
    var selectedStructId = ref.watch(selectedStructPod);

    return MouseRegion(
      cursor: cursor,
      child: Stack(
        children: [
          InteractiveViewer(
              transformationController: _transformationController,
              boundaryMargin: EdgeInsets.all(double.infinity),
              minScale: 0.1,
              maxScale: 5.0,
              constrained: false,
              onInteractionUpdate: _onInteractionUpdate,
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                width: 10000,  // Arbitrarily large width for the canvas
                height: 10000,  // Arbitrarily large height for the canvas
                child: Stack(
                  children: [
                    for (int i = 0; i < structs.length; i++)
                      Builder(
                        builder: (context) {
                          GlobalKey key = GlobalKey();
                          double width = (structs[i].data["size"] != null)
                              ? (double.tryParse(structs[i].data["size"]) ?? 300)
                              : 300 + (getMaxDepth(structs[i]) * 50);

                          if (i == 0) {
                            structKeys = {};
                            offset = width;
                            structKeys[structs[i].id] = key;
                          }

                          return StatefulBuilder(
                            builder: (context, setState) {
                              return Positioned(
                                left: 0,
                                top: 0,
                                child: Column(
                                  key: key,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onHorizontalDragUpdate: (details) {
                                          width += details.delta.dx;
                                          setState(() {
                                            resizeWidth = width;
                                          });
                                          },
                                      onHorizontalDragCancel: () {
                                        if (resizeWidth == null) return;
                                        Map<String, dynamic> newData = structs[i].data;
                                        newData["size"] = (resizeWidth).toString();
                                        ref.read(structsPod.notifier).editStructData(structs[i].id, newData);
                                        resizeWidth = null;
                                      },
                                      onHorizontalDragEnd: (_) {
                                        if (resizeWidth == null) return;
                                        Map<String, dynamic> newData = structs[i].data;
                                        newData["size"] = (resizeWidth).toString();
                                        ref.read(structsPod.notifier).editStructData(structs[i].id, newData);
                                        resizeWidth = null;
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Stack(
                                          children: [
                                            StructBuilder(
                                              onPan: _handlePanUpdate,
                                              dragIndex: i,
                                              struct: structs[i],
                                              bottomBorder: true,
                                              maxWidth: resizeWidth ?? width, // Dynamically update the width
                                            ),
                                            // Resize handle at the right edge
                                            Positioned(
                                              right: 0,
                                              top: 0,
                                              bottom: 0,
                                              child: MouseRegion(
                                                cursor: SystemMouseCursors.resizeLeftRight,
                                                child: Container(
                                                  width: 10, // Make the resize handle clickable
                                                  color: Colors.transparent, // Transparent handle
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      )
                  ],
                ),
              ),
            ),

          Positioned(
            left: leftPanelWidth +  16,
            bottom: 8,
            child: InkWell(
              onTap: () {
                showContextMenu(context, contextMenu: ContextMenu(
                    position: Offset(leftPanelWidth +  16, MediaQuery.sizeOf(context).height - 40),
                    entries: [
                      MenuItem(label: "Zoom in", onSelected: () => zoomCanvas(1.2)),
                      MenuItem(label: "Zoom out", onSelected: () => zoomCanvas(0.8)),
                      MenuItem(label: "Zoom to fit", onSelected: () {
                        zoomToFit(width, leftPanelWidth);
                      }),
                    ]
                ));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
                width: 50,
                height: 30,
                child: Center(child: Text("${(_currentScale * 100).toInt()}%")),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void zoomToFit(double width, double leftPanelWidth) {
    var selectedStructId = ref.read(selectedStructPod);
    Struct? rootStruct = ref.read(structsPod.notifier).findRootStruct(selectedStructId);
    if (rootStruct == null) return;
    GlobalKey? key = structKeys[rootStruct.id];
    if (key == null) return;
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    double heightZoomFactor = widget.height / box.size.height;
    double widthZoomFactor = width / box.size.width;
    if (heightZoomFactor < widthZoomFactor) {
      setExactZoom(heightZoomFactor);
      jumpToCoordinate(-leftPanelWidth, 0);
    } else {
      setExactZoom(widthZoomFactor);
      jumpToCoordinate(-leftPanelWidth, 0);
    }
  }
}

//maxWidth: (structs[i].data["size"] != null)? (double.tryParse(structs[i].data["size"]) ?? 300):300 + (getMaxDepth(structs[i]) * 50),
