import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:structogrammar/riverpod/state.dart';
import 'package:structogrammar/widgets/color_picker.dart';
import 'package:structogrammar/widgets/property_textfield.dart';

bool isValidHexColor(String input) {
  final hexColorRegex = RegExp(r'[a-fA-F0-9#]');
  return hexColorRegex.hasMatch(input);
}

class PropertyColorPicker extends ConsumerStatefulWidget {
  const PropertyColorPicker({super.key, required this.value, required this.onChanged});
  final String value;
  final Function(String) onChanged;
  @override
  ConsumerState createState() => _PropertyColorPickerState();
}

class _PropertyColorPickerState extends ConsumerState<PropertyColorPicker> {
  bool hovered = false;
  late String selectedValue;
  Function()? removeListener;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.value; // Initialize with the passed value
  }

  @override
  void didUpdateWidget(PropertyColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the selected value if the parent passes a new one
    if (oldWidget.value != widget.value) {
      setState(() {
        selectedValue = widget.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorPicker = ref.watch(colorPickerPod);
    return PropertyTextfield(onlyColor: true, prefix: Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4,top: 4 ),
      child: InkWell(
        onTap: () async {
          try{
          if (colorPicker != null) {
            ref.read(colorPickerPod.notifier).state =null;
            removeListener?.call();
          } else {
            if (removeListener == null) {

              ref.read(colorPickerPod.notifier).state = null;
              await Future.delayed(Duration(milliseconds: 10));
            }
            ref.read(colorPickerPod.notifier).state = HexColor(selectedValue);
           removeListener = ref.read(colorPickerPod.notifier).addListener((newColor) {
             if (newColor == null) {
               removeListener?.call();
               return;
             }
              widget.onChanged.call(newColor.toHexString(includeHashSign: true, enableAlpha: false) ?? selectedValue);
            }, fireImmediately: true);
          }} catch(_) {}
        },
        child: Container(
          height: 12,
          width: 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: Colors.grey),
            color: HexColor(selectedValue)
          ),
        ),
      ),
    ), onChanged: (value) {
      if (isValidHexColor(value)) {
        widget.onChanged.call(value);
        if (colorPicker != null) {
          ref.read(colorPickerPod.notifier).state = null;
        }
      }
     }, fieldName: "", value: selectedValue);
  }
}
