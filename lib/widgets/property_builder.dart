import 'package:flutter/material.dart';
import 'package:structogrammar/widgets/property_color_picker.dart';
import 'package:structogrammar/widgets/property_dropdown.dart';
import 'package:structogrammar/widgets/property_section.dart';
import 'package:structogrammar/widgets/property_textfield.dart';

class PropertyBuilder extends StatefulWidget {
  const PropertyBuilder({super.key, required this.property, required this.onChanged});
  final SectionProperty property;
  final Function(String, dynamic) onChanged;
  @override
  State<PropertyBuilder> createState() => _PropertyBuilderState();
}

class _PropertyBuilderState extends State<PropertyBuilder> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Builder(builder: (context) {
        switch (widget.property.propertyType) {
          case PropertyType.string:
           return PropertyTextfield(fieldName: "", value: widget.property.propertyValue,maxLines: 5, onChanged: (value) {
             widget.onChanged.call(widget.property.propertyKey, value);
           },);
          case PropertyType.int:
            return PropertyTextfield(fieldName: "",onlyInt: true, value: widget.property.propertyValue.toString(), onChanged: (value) {
              widget.onChanged.call(widget.property.propertyKey, int.tryParse(value)  ?? widget.property.propertyValue);
            },);
          case PropertyType.dropdown:
            return PropertyDropdown(possibleValues: widget.property.possibleValues ?? [widget.property.propertyValue], value: widget.property.propertyValue, onChanged: (value){
              widget.onChanged.call(widget.property.propertyKey, value);
            });
          case PropertyType.color:
            return PropertyColorPicker(value: widget.property.propertyValue, onChanged: (value){
              widget.onChanged.call(widget.property.propertyKey, value);
            });
          default:
            return PropertyTextfield(fieldName: "", value: widget.property.propertyValue, onChanged: (value) {
              widget.onChanged.call(widget.property.propertyKey, value);
            },);
        }
      }),
    );
  }
}
