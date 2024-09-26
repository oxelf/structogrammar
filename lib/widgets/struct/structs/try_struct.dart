import 'package:flutter/material.dart';
import 'package:structogrammar/models/struct.dart';
import 'package:structogrammar/widgets/struct/struct_widget.dart';

class TryStruct extends StatelessWidget {
  const TryStruct({
    super.key,
    required this.struct,
    required this.width,
  });

  final Struct struct;
  final double width;

  @override
  Widget build(BuildContext context) {
    var subStructs = struct.subStructs.toList() ?? [];
    List<Struct> catchStructs = [];
    Struct? catchStruct;
    try {
      catchStructs = subStructs
          .firstWhere((e) => e.type == StructType.catchStatement)
          .subStructs ?? [];
      catchStruct = subStructs.firstWhere((e) => e.type == StructType.catchStatement);
      subStructs.removeWhere((e) => e.type == StructType.catchStatement);
    } catch (e) {}
    return IntrinsicHeight(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "try",
                  style: struct.structTextStyle?.toTextStyle(),
                ),
              ],
            ),
          ),
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
                      width: width - 36,
                      borders: [
                        StructBorder.left,
                        StructBorder.top,
                        StructBorder.right,
                        if (i + 1 == subStructs.length) StructBorder.bottom,
                      ],
                    ),
                ],
              ),
              const SizedBox(width: 12,),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Row(
              children: [
                Text("catch: ${catchStruct?.primaryValue}"),
              ],
            ),
          ),
          Row(
            children: [

              const Icon(Icons.chevron_right, size: 24),
              Column(
                children: [
                  for (int i = 0; i < catchStructs.length; i++)
                    StructWidget(
                      struct: catchStructs[i],
                      width: width - 36,
                      borders: [
                        StructBorder.left,
                        StructBorder.top,
                        StructBorder.right,
                        if (i + 1 == catchStructs.length) StructBorder.bottom,
                      ],
                    ),
                ],
              ),const SizedBox(
                width: 12,
              ),
            ],
          ),
          const SizedBox(height: 16,),
        ],
      ),
    );
  }
}
