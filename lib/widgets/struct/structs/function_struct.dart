import 'package:flutter/material.dart';
import 'package:structogrammar/models/struct.dart';
import 'package:structogrammar/widgets/struct/struct_widget.dart';

class FunctionStruct extends StatelessWidget {
  const FunctionStruct({
    super.key,
    required this.struct,
    required this.width,
  });

  final Struct struct;
  final double width;

  @override
  Widget build(BuildContext context) {
    var subStructs = struct.subStructs.toList() ?? [];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
          child: Row(
            children: [
              Text(struct.primaryValue, style: struct.structTextStyle?.toTextStyle(),),
            ],
          ),
        ),
        IntrinsicHeight(
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 0,
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (int i = 0; i < subStructs.length; i++)
                      StructWidget(
                        struct: subStructs[i],
                        width: width - 32,
                        borders: [
                          StructBorder.left,
                          StructBorder.right,
                          if (i == 0) StructBorder.top,
                          StructBorder.bottom
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
