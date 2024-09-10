import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/riverpod/state.dart';

class FloatingColorPicker extends ConsumerStatefulWidget {
  const FloatingColorPicker({super.key});

  @override
  ConsumerState createState() => _ColorPickerState();
}

class _ColorPickerState extends ConsumerState<FloatingColorPicker> {
  @override
  Widget build(BuildContext context) {
    var color = ref.watch(colorPickerPod)!;
    var rightPanelWidth = ref.watch(rightFloatingPanelWidthPod);
    return Positioned(
      right: rightPanelWidth + 16,
      bottom: 16,
      child: Container(
        height: 550,
        width: 250,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: SizedBox(

          child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Row(
                      children: [
                        IconButton(onPressed: () {
                          try{
                       ref.read(colorPickerPod.notifier).state = null;} catch(_) {}
                        }, icon: Icon(Icons.close)),
                      ],
                    ),
                    Divider(),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          ColorPicker(
                            portraitOnly: true,
                            pickerColor: color,
                            onColorChanged: (Color color) {
                              ref.read(colorPickerPod.notifier).state = color;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
          ),
        ),
      ),
    );
  }
}
