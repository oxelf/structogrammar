import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:structogrammar/main.dart';

import '../models/struct.dart';

Future<List<Struct>?> importCode() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  if (result == null) return null;
  String code = File(result.files.first.path ?? "").readAsStringSync();
  List<Struct> parsed = cppParser.parseTree(code);
  return parsed;
}