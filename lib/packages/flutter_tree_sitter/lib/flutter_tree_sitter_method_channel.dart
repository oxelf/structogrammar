import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tree_sitter/grammars.dart';
import 'flutter_tree_sitter_platform_interface.dart';

class MethodChannelFlutterTreeSitter extends FlutterTreeSitterPlatform {
  final MethodChannel _methodChannel = const MethodChannel('flutter_tree_sitter');

  @override
  Future<String?> parseCode(String code, TreeSitterLanguage language) async {
    String grammarPath = "";
    if (kIsWeb) {
      grammarPath = language.webFile ?? "";
    } else if (Platform.isWindows) {
      grammarPath = language.windowsFile ?? "";
    }else if (Platform.isMacOS) {
      grammarPath = language.macosFile ?? "";
    }else if (Platform.isLinux) {
      grammarPath = language.linuxFile ?? "";
    }
    final String? result = await _methodChannel.invokeMethod('parseCode', {"code": code, "grammar": grammarPath});
    return result;
  }
}