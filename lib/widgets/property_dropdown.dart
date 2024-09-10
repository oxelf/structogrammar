import 'package:flutter/material.dart';

class PropertyDropdown extends StatefulWidget {
  const PropertyDropdown({
    super.key,
    required this.possibleValues,
    required this.value,
    required this.onChanged,
  });

  final List<String> possibleValues;
  final String value;
  final Function(String) onChanged;

  @override
  State<PropertyDropdown> createState() => _PropertyDropdownState();
}

class _PropertyDropdownState extends State<PropertyDropdown> {
  bool hovered = false;
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.value; // Initialize with the passed value
  }

  @override
  void didUpdateWidget(PropertyDropdown oldWidget) {
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
    return MouseRegion(
      onHover: (_) {
        if (hovered) return;
        setState(() {
          hovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          hovered = false;
        });
      },
      child: Container(
        height: 28,
        padding: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Color.fromRGBO(245, 245, 245, 1),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: hovered ? Colors.grey : Colors.transparent,
            width: 0,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: DropdownButton<String>(
              value: selectedValue,
              isDense: true,
              isExpanded: true,
              iconSize: 20,
              iconEnabledColor: Colors.grey,
              icon: Icon(Icons.arrow_drop_down),
              style: TextStyle(fontSize: 12, color: Colors.black),
              dropdownColor: Color.fromRGBO(245, 245, 245, 1),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedValue = newValue;
                  });
                  widget.onChanged(newValue); // Call the parent callback
                }
              },
              items: widget.possibleValues.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: SizedBox(
                    height: 20, // Set the desired height for each item
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(value),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}