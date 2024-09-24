abstract class TreeSitterLanguage {
  final String? language;
  final String? webFile;
  final String? windowsFile;
  final String? macosFile;
  final String? linuxFile;

  TreeSitterLanguage(
    this.language,
    this.webFile,
    this.windowsFile,
    this.macosFile,
    this.linuxFile,
  );
}

class TreeSitterCpp implements TreeSitterLanguage {
  TreeSitterCpp();

  @override
  String? get language => "cpp";

  @override
  String? get linuxFile => throw UnimplementedError();

  @override
  String? get macosFile => throw UnimplementedError();

  @override
  String? get webFile => "tree-sitter-cpp.wasm";

  @override
  String? get windowsFile => throw UnimplementedError();
}
