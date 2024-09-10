import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HexColorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final hexRegex = RegExp(r'[a-fA-F0-9#]');

    if (hexRegex.hasMatch(newValue.text) || newValue.text.isEmpty) {
      return newValue;
    } else {
      return oldValue;
    }
  }
}

class PropertyTextfield extends StatefulWidget {
  const PropertyTextfield({
    super.key,
    required this.fieldName,
    required this.value,
    this.onCompleted,
    this.onChanged,
    this.prefix,
    this.suffix,
    this.onlyInt,
    this.onlyColor,
    this.maxLines,
  });

  final String fieldName;
  final String value;
  final Widget? prefix;
  final Widget? suffix;
  final bool? onlyInt;
  final bool? onlyColor;
  final int? maxLines;
  final Function(String)? onCompleted;
  final Function(String)? onChanged;

  @override
  State<PropertyTextfield> createState() => _PropertyTextfieldState();
}

class _PropertyTextfieldState extends State<PropertyTextfield> {
  bool hovered = false;
  late TextEditingController _controller;
  int _lineCount = 1; // Start with 1 line

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _updateLineCount(widget.value);
  }

  @override
  void didUpdateWidget(PropertyTextfield oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = widget.value;
      _updateLineCount(widget.value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateLineCount(String text) {
    // Calculate line count based on text
    final lines = '\n'.allMatches(text).length + 1;
    if (lines > (widget.maxLines ?? 1)) {
      setState(() {
        _lineCount = widget.maxLines ?? 1;
      });
    } else {
      setState(() {
        _lineCount = lines;
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
        height: _lineCount * 28, // Line count multiplied by 28 pixels
        color: Color.fromRGBO(245, 245, 245, 1),
        child: TextField(
          controller: _controller,
          textAlignVertical: TextAlignVertical.top,
          minLines: 1,
          maxLines: widget.maxLines ?? 1,
          onChanged: (value) {
            widget.onChanged?.call(value);
            _updateLineCount(value); // Update line count on text change
          },
          cursorHeight: 16,
          cursorColor: Colors.black,
          cursorWidth: 1,
          style: TextStyle(fontSize: 12),
          inputFormatters: <TextInputFormatter>[
            if (widget.onlyInt == true) FilteringTextInputFormatter.digitsOnly,
            if (widget.onlyColor == true) FilteringTextInputFormatter.allow(RegExp(r'[a-fA-F0-9#]')),
          ],
          decoration: InputDecoration(
            prefix: widget.prefix,
            suffix: widget.suffix,
            contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 0),
              borderRadius: BorderRadius.circular(4),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: hovered ? Colors.grey : Colors.transparent,
                width: 0,
              ),

              borderRadius: BorderRadius.circular(4),
            ),
          )
        ),
      ),
    );
  }
}