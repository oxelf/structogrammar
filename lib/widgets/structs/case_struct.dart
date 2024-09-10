import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/models/struct.dart';
import 'package:structogrammar/riverpod/structs.dart';

import '../../riverpod/state.dart';
import '../struct_builder.dart';

class CaseStructWidget extends ConsumerWidget {
  const CaseStructWidget({
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
    double topHeight = 60;
    Map<String, List<Struct>> cases = {};
   struct.subStructs.forEach((s) {
     if (cases[s.data["case"]] == null) {
       cases[s.data["case"] ?? ""] = [s];
     } else {
       cases[s.data["case"]]!.add(s);
     }
   });
   double caseWidth = (maxWidth - 4) / cases.length;
    return Container(
      child: IntrinsicHeight(
        child: Column(
          children: [
            Container(
              height: topHeight,
              child: Stack(
                children: [
                  Container(
                    width: maxWidth,
                    height: topHeight,
                    child: CustomPaint(
                      painter: CaseLinePainter(offset: maxWidth- 4 - caseWidth, caseWidth: caseWidth),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int i = 0; i < cases.length - 1; i++) SizedBox(),
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
                              overflow: TextOverflow.clip,
                              struct.data["condition"].toString(),
                              style: style,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      for (int i = 0; i <cases.length; i++)
                      SizedBox(
                        width: caseWidth,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(height: 20,),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(cases.keys.elementAt(i), textAlign: TextAlign.center, overflow: TextOverflow.fade,),
                            ),
                          ],
                        ),
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
              return Stack(
                children: [
                  Container(
                    color: Colors.white,
                    child: IntrinsicHeight(
                      child: SizedBox(
                        width: maxWidth,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (int j = 0;j < cases.length; j++)
                                SizedBox(
                                  width: calculateCaseWidth(j, cases.length, caseWidth),
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          for (int i = 0; i < cases.values.elementAt(j).length; i++)
                                            StructBuilder(
                                              struct: cases.values.elementAt(j)[i],
                                              maxWidth: calculateSubStructWidth(j, cases.length, caseWidth),
                                              noRightBorder: true,
                                              noLeftBorder: true,
                                              noTopBorder: (i == 0),
                                              bottomBorder: false,
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),


                            // Vertical line between columns
                            // Second column

                          ],
                        ),
                      ),
                    ),
                  ),

                  for (int i = 0; i < cases.length; i++) Positioned(
                    left:  caseWidth * i - (((parent?.type ?? StructType.function) == StructType.function)?1: 1),
                    child: (i == 0)?SizedBox(): Container(width: 2, color: Colors.black, height: 10000),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
  double calculateCaseWidth(int i,int n, double caseWidth) {
    return caseWidth;
  }
  double calculateSubStructWidth(int i,int n, double caseWidth) {
   return caseWidth;
  }
}

class CaseLinePainter extends CustomPainter {
  double offset;
  double caseWidth;
  CaseLinePainter({required this.offset, required this.caseWidth});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    // Draw line from top-left to bottom-center
    canvas.drawLine(
      Offset(0, 0), // Top-left corner
      Offset(offset, size.height - 20), // Bottom-center
      paint,
    );

    // Draw line from top-right to bottom-center
    canvas.drawLine(
      Offset(size.width, 0), // Top-right corner
      Offset(offset, size.height - 20), // Bottom-center
      paint,
    );

    for (int i = 0; i < (size.width / caseWidth).toInt(); i++) {
      if (i == 0) continue;

      double widthOffset = caseWidth * i;


      // Calculate the height of the vertical line based on the left diagonal
      double lineHeight = (size.height - 20) * widthOffset / offset;

      // Draw the vertical line
      canvas.drawLine(
        Offset(widthOffset, size.height), // Start from the bottom
        Offset(widthOffset, lineHeight),  // Connect to the diagonal line
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
