import 'package:flutter_tree_sitter/grammars.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'flutter_tree_sitter_method_channel.dart';

abstract class FlutterTreeSitterPlatform extends PlatformInterface {
  FlutterTreeSitterPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterTreeSitterPlatform _instance = MethodChannelFlutterTreeSitter();

  static FlutterTreeSitterPlatform get instance => _instance;

  static set instance(FlutterTreeSitterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> parseCode(String code, TreeSitterLanguage language) {
    throw UnimplementedError('parseCode() has not been implemented.');
  }
}