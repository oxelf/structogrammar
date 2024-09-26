import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:structogrammar/main.dart';
import 'package:toastification/toastification.dart';

import '../models/struct.dart';

Future<List<Struct>?> importCode() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  if (result == null) return null;
  String code = File(result.files.first.path ?? "").readAsStringSync();
  try {
    List<Struct> parsed = cppParser.parseTree(code);
    return parsed;
  } catch (e) {
    toastification.show(
      context: navigatorKey.currentContext,
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      title: const Text("Parsing failed"),
      description:
      const Text("Check the code for semantic errors"),
      alignment: Alignment.bottomRight,
      autoCloseDuration: const Duration(seconds: 4),
      boxShadow: lowModeShadow,
    );
  }
  return null;
}
