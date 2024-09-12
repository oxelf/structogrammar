import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/widgets/property_textfield.dart';


class PropertyListWidget extends ConsumerStatefulWidget {
  const PropertyListWidget({super.key, required this.value, required this.onChanged});
  final List<String> value;
  final Function(List<String>) onChanged;
  @override
  ConsumerState createState() => _PropertyColorPickerState();
}

class _PropertyColorPickerState extends ConsumerState<PropertyListWidget> {
  bool hovered = false;
  late List<String> selectedValue;
  Function()? removeListener;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.value; // Initialize with the passed value
  }

  @override
  void didUpdateWidget(PropertyListWidget oldWidget) {
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
    return PropertyTextfield(onlyColor: true, onChanged: (value) {
      print("new: $value");
    }, fieldName: "", value: selectedValue.first);
  }
}