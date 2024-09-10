import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class ConditionalDottedBorder extends StatelessWidget {
  const ConditionalDottedBorder({super.key,required this.child, required this.dotted});
  final Widget child;
  final bool dotted;
  @override
  Widget build(BuildContext context) {
    return (dotted)? DottedBorder(color: Colors.blue[400] ?? Colors.blue, child: child): child;
  }
}
