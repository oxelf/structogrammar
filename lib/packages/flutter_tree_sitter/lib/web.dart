import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:js/js_util.dart' as js_util;

class FlutterTreeSitterWeb {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'flutter_tree_sitter',
      const StandardMethodCodec(),
      registrar.messenger,
    );
    final FlutterTreeSitterWeb instance = FlutterTreeSitterWeb();
    channel.setMethodCallHandler(instance.handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'parseCode':
        final String code = call.arguments['code'];
        final String grammar = call.arguments['grammar'];
        return _parseCode(code, grammar);
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: "The FlutterTreeSitterWeb plugin doesn't implement the method '${call.method}'",
        );
    }
  }

  Future<String?> _parseCode(String code, String grammar) async {
    try {
      // Initialize TreeSitter
      final TreeSitter = js_util.getProperty(js_util.globalThis, 'TreeSitter');
      if (TreeSitter == null) {
        throw Exception('TreeSitter is not available');
      }

      await js_util.callMethod(TreeSitter, 'init', []);

      final Parser = js_util.getProperty(TreeSitter, 'Parser');
      if (Parser == null) {
        throw Exception('Parser is not available on TreeSitter');
      }

      final parser = js_util.callConstructor(Parser, []);

      final Language = js_util.getProperty(TreeSitter, 'Language');
      if (Language == null) {
        throw Exception('Language is not available on TreeSitter');
      }

      final language = await js_util.callMethod(Language, 'load', [grammar]);
      js_util.callMethod(parser, 'setLanguage', [language]);

      final tree = js_util.callMethod(parser, 'parse', [code]);
      final rootNode = js_util.getProperty(tree, 'rootNode');
      final result = js_util.callMethod(rootNode, 'toString', []);

      return result as String?;
    } catch (e) {
      return 'Error parsing code: $e';
    }
  }
}