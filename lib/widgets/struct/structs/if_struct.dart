import 'package:flutter/material.dart';
import 'package:structogrammar/models/struct.dart';
import 'package:structogrammar/util/app_colors.dart';
import 'package:structogrammar/widgets/struct/struct_widget.dart';

class IfStruct extends StatelessWidget {
  const IfStruct({
    super.key,
    required this.struct,
    required this.width,
  });

  final Struct struct;
  final double width;

  @override
  Widget build(BuildContext context) {
    var trueStructs = [];
    var falseStructs = [];
    try {
      trueStructs = struct.subStructs
         .firstWhere((e) =>
              e.type == StructType.ifCondition && e.primaryValue == "true")
          .subStructs ?? [];
      falseStructs = struct.subStructs
          .firstWhere((e) =>
              e.type == StructType.ifCondition && e.primaryValue == "false")
          .subStructs ?? [];
    } catch (e) {}
    return Container(
      child: IntrinsicHeight(
        child: Column(
          children: [
            SizedBox(
              width: width,
              height: 50,
              child: Stack(
                children: [
                  SizedBox(
                    width: width,
                    height: 50,
                    child: CustomPaint(
                      painter: IfLinePainter(),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                    child: SizedBox(
                      width: width - 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: width - 16,
                                height: 20,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      struct.primaryValue,
                                      style: struct.structTextStyle?.toTextStyle(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text("true"), Text("false")],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: Container(
                  height: 1,
                  color: AppColors.borderColor,
                )),
              ],
            ),
            Builder(
              builder: (context) {
                return Container(
                  color: Colors.white,
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              for (int i = 0; i < trueStructs.length; i++)
                                StructWidget(
                                  struct: trueStructs[i],
                                  width: width / 2 - 1,
                                  borders: [
                                    if (i + 1 != trueStructs.length) StructBorder.bottom
                                  ],
                                ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          color: AppColors.borderColor,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              for (int i = 0; i < falseStructs.length; i++)
                                StructWidget(
                                  struct: falseStructs[i],
                                  width: width / 2,
                                  borders: [
                                    if (i + 1 != falseStructs.length)
                                      StructBorder.bottom
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            ),
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
      ..color = AppColors.borderColor
      ..strokeWidth = 1.0;

    // Draw line from top-left to bottom-center
    canvas.drawLine(
      const Offset(0, 0), // Top-left corner
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
