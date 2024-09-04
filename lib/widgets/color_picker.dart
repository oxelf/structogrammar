import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:structogrammar/riverpod/structs.dart';

class ColorPicker extends ConsumerStatefulWidget {
  const ColorPicker({super.key, required this.color, required this.onChanged});
  final String color;
  final Function(String) onChanged;
  @override
  ConsumerState createState() => _ColorPickerState();
}

class _ColorPickerState extends ConsumerState<ColorPicker> {
  List<String> colors = ["#FFFFFF", "#ff767c", "#ffff68", "#38ff6d", "#38ffff", "#0082ff", "#ff76c2", "#c0c0c0", "#ff7600", "#8080ff"];

  @override
  Widget build(BuildContext context) {
    var structs = ref.watch(structsPod);
    return Wrap(
      spacing: 10,
      runSpacing: 20,
      direction: Axis.horizontal,
      runAlignment: WrapAlignment.start,
      children: [
        for (var color in colors)
          InkWell(
              onTap: () {
                widget.onChanged.call(color);
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: HexColor(color),
                  border: Border.all(
                      color: Colors.black,
                      width: (widget.color == color) ? 3 : 1),
                ),
                height: 30,
                width: 30,
              )),
      ],
    );
  }
}

