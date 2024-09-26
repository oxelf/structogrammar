import 'package:flutter/material.dart';
import 'package:structogrammar/models/struct.dart';

class InstructionStruct extends StatefulWidget {
  const InstructionStruct({
    super.key,
    required this.struct,
    required this.width,
  });

  final Struct struct;
  final double width;

  @override
  State<InstructionStruct> createState() => _InstructionStructState();
}

class _InstructionStructState extends State<InstructionStruct> {
  TextEditingController textEditingController = TextEditingController();
  bool editing = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(widget.struct.primaryValue,  overflow: TextOverflow.visible, ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
