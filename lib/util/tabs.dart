import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:structogrammar/models/tab.dart';
import 'package:structogrammar/util/uuid.dart';

STab createTab(int projectId) {
  return STab(
      tabId: generateUUID(),
      projectId: projectId,
      icon: const Icon(FontAwesomeIcons.rectangleList, size: 16,),
      closable: true);
}
