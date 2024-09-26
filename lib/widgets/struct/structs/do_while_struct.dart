import 'package:flutter/material.dart';
import 'package:structogrammar/models/struct.dart';
import 'package:structogrammar/widgets/struct/struct_widget.dart';

class DoWhileStruct extends StatelessWidget {
  const DoWhileStruct({
    super.key,
    required this.struct,
    required this.width,
  });

  final Struct struct;
  final double width;

  @override
  Widget build(BuildContext context) {
    var subStructs = struct.subStructs.toList() ?? [];
    return IntrinsicHeight(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 24,
              ),
              Column(
                children: [
                  for (int i = 0; i < subStructs.length; i++)
                    StructWidget(
                      struct: subStructs[i],
                      width: width - 24,
                      borders: [
                        StructBorder.left,
                        if (i + 1== subStructs.length) StructBorder.bottom,
                        if (i  != 0) StructBorder.top
                      ],
                    ),
                ],
              )

            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  struct.primaryValue,
                  style: struct.structTextStyle?.toTextStyle(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
