import 'package:flutter/material.dart';

class STab {
  final String tabId;
  final int projectId;
  final Widget icon;
  final bool closable;

  STab({
    required this.tabId,
    required this.projectId,
    required this.icon,
    required this.closable,
  });
}
