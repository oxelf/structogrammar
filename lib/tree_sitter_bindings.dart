// import 'dart:ffi';
// import 'dart:io';
// import 'package:ffi/ffi.dart';
// import 'package:path/path.dart' as path;
//
// // Load the Tree-sitter dynamic library
// final DynamicLibrary treeSitterLib = Platform.isMacOS
//     ? DynamicLibrary.open(path.join(Directory.current.path, 'libtree-sitter.dylib'))
//     : DynamicLibrary.open('libtree-sitter.so'); // For Linux/Windows
//
// // Binding for ts_parser_new
// typedef TsParserNewNative = Pointer<Void> Function();
// typedef TsParserNew = Pointer<Void> Function();
// final TsParserNew tsParserNew = treeSitterLib
//     .lookup<NativeFunction<TsParserNewNative>>('ts_parser_new')
//     .asFunction();
//
// // Binding for ts_parser_set_language
// typedef TsParserSetLanguageNative = Int32 Function(Pointer<Void> parser, Pointer<Void> language);
// typedef TsParserSetLanguage = int Function(Pointer<Void> parser, Pointer<Void> language);
// final TsParserSetLanguage tsParserSetLanguage = treeSitterLib
//     .lookup<NativeFunction<TsParserSetLanguageNative>>('ts_parser_set_language')
//     .asFunction();
//
// // Binding for ts_parser_parse_string
// typedef TsParserParseStringNative = Pointer<Void> Function(
//     Pointer<Void> parser, Pointer<Void> oldTree, Pointer<Utf8> input, Uint32 length);
// typedef TsParserParseString = Pointer<Void> Function(
//     Pointer<Void> parser, Pointer<Void> oldTree, Pointer<Utf8> input, int length);
// final TsParserParseString tsParserParseString = treeSitterLib
//     .lookup<NativeFunction<TsParserParseStringNative>>('ts_parser_parse_string')
//     .asFunction();
//
// // Binding for ts_node_string
// typedef TsNodeStringNative = Pointer<Utf8> Function(Pointer<Void> node);
// typedef TsNodeString = Pointer<Utf8> Function(Pointer<Void> node);
// final TsNodeString tsNodeString = treeSitterLib
//     .lookup<NativeFunction<TsNodeStringNative>>('ts_node_string')
//     .asFunction();
//
// // Placeholder for your Tree-sitter language (like C, JSON, etc.)
// final DynamicLibrary languageLib = DynamicLibrary.open(path.join(Directory.current.path, 'cpp.dylib'));
//
// // Binding for the language (e.g., ts_language_cpp from libcpp.dylib)
// typedef TsLanguageCppNative = Pointer<Void> Function();
// typedef TsLanguageCpp = Pointer<Void> Function();
// final TsLanguageCpp tsLanguageCpp = languageLib
//     .lookup<NativeFunction<TsLanguageCppNative>>('tree_sitter_cpp')
//     .asFunction();