import 'package:flutter/material.dart';
import 'package:structogrammar/models/struct.dart';

class InstructionStruct extends StatelessWidget {
  const InstructionStruct({
    super.key,
    required this.struct,
    required this.width,
  });

  final Struct struct;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
            child: Row(

              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(struct.primaryValue,  overflow: TextOverflow.visible, ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
