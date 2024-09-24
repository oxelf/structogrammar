import 'package:flutter_tree_sitter/grammars.dart';

import 'flutter_tree_sitter_platform_interface.dart';
export 'grammars.dart';


class FlutterTreeSitter {
  // This method will call the platform-specific `parseCode` implementation.
  Future<String?> parseCode(String code, TreeSitterLanguage language) {
    return FlutterTreeSitterPlatform.instance.parseCode(code, language);
  }
}