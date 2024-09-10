import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/models/struct.dart';
import 'package:structogrammar/riverpod/structs.dart';

import '../../riverpod/state.dart';
import '../struct_builder.dart';

class IFStructWidget extends ConsumerWidget {
  const IFStructWidget({
    super.key,
    required this.struct,
    required this.maxWidth,
  });

  final Struct struct;
  final double maxWidth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String selectedStruct = ref.watch(selectedStructPod);
    Struct? parent = ref.read(structsPod.notifier).findParentStruct(struct.id);
    TextStyle style = textStyleFromMap(struct.data, "text");
    return Container(
      child: IntrinsicHeight(
        child: Column(
          children: [
            Container(
              height: ((struct.data["comment"] ?? "") != "") ? 60 : 40,
              child: Stack(
                children: [
                  Container(
                    width: maxWidth,
                    height: ((struct.data["comment"] ?? "") != "") ? 60 : 40,
                    child: CustomPaint(
                      painter: IfLinePainter(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if ((struct.data["comment"] ?? "") != "")
                            Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Text(
                                struct.data["comment"].toString(),
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 10),
                              ),
                            ),
                          Expanded(
                            child: Text(
                              overflow: TextOverflow.visible,
                              struct.data["condition"].toString(),
                              style:style,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text("true"),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text("false"),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            Row(
              children: [
                Expanded(child: Container( height: 2, color: Colors.black,)),
              ],
            ),
            Builder(builder: (context) {
              var trueStructs = struct.subStructs
                  .where((e) => e.data["ifValue"] == true)
                  .toList();
              var falseStructs = struct.subStructs
                  .where((e) => e.data["ifValue"] == false)
                  .toList();

              return Container(
                color: Colors.white,
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // First column
                      Expanded(
                        child: Column(
                          children: [
                            for (int i = 0; i < trueStructs.length; i++)
                              StructBuilder(
                                struct: trueStructs[i],
                                // - 2 because of the border
                                maxWidth: (maxWidth / 2.0) - (((parent?.type ?? StructType.instruction) == StructType.function)? 3: 1),
                                noRightBorder: true,
                                noLeftBorder: true,
                                noTopBorder: (i == 0),
                                bottomBorder: (i + 1 == trueStructs.length &&
                                    trueStructs.length < falseStructs.length),
                              ),
                          ],
                        ),
                      ),
                      // Vertical line between columns
                      Container(
                        width: 2,
                        color: Colors.black,
                      ),
                      // Second column
                      Expanded(
                        child: Column(
                          children: [
                            for (int i = 0; i < falseStructs.length; i++)
                              StructBuilder(
                                struct: falseStructs[i],
                                maxWidth: (maxWidth / 2.0) - (((parent?.type ?? StructType.instruction) == StructType.function)? 3: 1),
                                noTopBorder: (i == 0),
                                noRightBorder: true,
                                noLeftBorder: true,
                                bottomBorder: (i + 1 == falseStructs.length &&
                                    trueStructs.length > falseStructs.length),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class IfLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    // Draw line from top-left to bottom-center
    canvas.drawLine(
      Offset(0, 0), // Top-left corner
      Offset(size.width / 2, size.height), // Bottom-center
      paint,
    );

    // Draw line from top-right to bottom-center
    canvas.drawLine(
      Offset(size.width, 0), // Top-right corner
      Offset(size.width / 2, size.height), // Bottom-center
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
