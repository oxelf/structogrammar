import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:structogrammar/models/struct.dart';
import 'package:tree_sitter/tree_sitter.dart';
import 'package:path/path.dart' as path;

class CppParser {
  late Parser _parser;

  void init() async {
    TreeSitterConfig.setLibraryPath(path.join(
        (await getApplicationDocumentsDirectory()).path,
        'libtree-sitter.dylib'));
    _parser = Parser(
        sharedLibrary: 'Documents/cpp.dylib', entryPoint: 'tree_sitter_cpp');
  }

  List<Struct> parseTree(String sourceCode) {
    DateTime startTime = DateTime.now();
    final tree = _parser.parse(sourceCode);
    TSNode rootNode = tree.root;
    List<Struct> functionNodes = findFunctionNodes(rootNode, sourceCode);
    DateTime endTime = DateTime.now();
    print(
        "parsing took ${endTime.difference(startTime).inMilliseconds}ms, parsed: ${functionNodes.map((e) => e.primaryValue).toList().join(", ")}");
    return functionNodes;
  }

  Struct parseFunctionNode(TSNode functionNode, String code) {
    TSNode functionNameNode = functionNode.childByFieldName("declarator");
    String functionName =
        code.substring(functionNameNode.startByte, functionNameNode.endByte);
    return Struct(
        type: StructType.function,
        primaryValue: functionName,
        structTextStyle: StructTextStyle.functionStyle());
  }

  List<Struct> findFunctionNodes(TSNode node, String code) {
    List<Struct> functionStructs = [];
    if (node.nodeType == "function_definition") {
      Struct struct = parseFunctionNode(node, code);
      List<Struct> subStructs = [];
      subStructs.addAll(extractNodes(node.childByFieldName("body"), code));
      struct.subStructs = subStructs;
      functionStructs.add(struct);
    }
    for (int i = 0; i < node.namedChildCount; i++) {
      var child = node.namedChild(i);
      functionStructs.addAll(findFunctionNodes(child, code));
    }
    return functionStructs;
  }

  List<Struct> extractNodes(TSNode node, String code) {
    List<Struct> structs = [];
    for (int i = 0; i < node.namedChildCount; i++) {
      var child = node.namedChild(i);
      if (child.isNull) {
        continue;
      }
      switch (child.nodeType) {
        case "compound_statement":
          var nodes = extractNodes(child, code);
          structs.addAll(nodes);
          break;
        case "return_statement":
          var bodyNode = Struct(
              primaryValue: code.substring(child.startByte, child.endByte));
          structs.add(bodyNode);
          break;
        case "expression_statement":
          var bodyNode = Struct(
              primaryValue: code.substring(child.startByte, child.endByte));
          structs.add(bodyNode);
          break;
        case "declaration":
          var bodyNode = Struct(
              primaryValue: code.substring(child.startByte, child.endByte));
          structs.add(bodyNode);
          break;
        case "for_statement":
          TSNode declaration = child.childByFieldName("initializer");
          TSNode condition = child.childByFieldName("condition");
          TSNode update = child.childByFieldName("update");
          String value = "";
          if (!declaration.isNull && !update.isNull) {
            value = code.substring(declaration.startByte, update.endByte);
          }
          if (!declaration.isNull && update.isNull && !condition.isNull) {
            value = code.substring(declaration.startByte, condition.endByte);
          }
          if (declaration.isNull && !update.isNull) {
            value = code.substring(condition.startByte, update.endByte);
          }
          var bodyNode = Struct(type: StructType.forLoop, primaryValue: value);
          var nodes = extractNodes(child.childByFieldName("body"), code);
          bodyNode.subStructs = nodes;
          structs.add(bodyNode);
          break;
        case "while_statement":
          TSNode condition = child.childByFieldName("condition");
          String value = "?";
          if (!condition.isNull) {
            value = code.substring(condition.startByte, condition.endByte);
          }
          var bodyNode =
              Struct(type: StructType.whileLoop, primaryValue: value);
          var nodes = extractNodes(child.childByFieldName("body"), code);
          bodyNode.subStructs = nodes;
          structs.add(bodyNode);
          break;
        case "do_statement":
          TSNode condition = child.childByFieldName("condition");
          String value = "?";
          if (!condition.isNull) {
            value = code.substring(condition.startByte, condition.endByte);
          }
          var bodyNode =
              Struct(type: StructType.doWhileLoop, primaryValue: value);
          var nodes = extractNodes(child.childByFieldName("body"), code);
          bodyNode.subStructs = nodes;
          structs.add(bodyNode);
          break;
        case "if_statement":
          var condition =
              child.childByFieldName("condition").childByFieldName("value");
          var value = code.substring(condition.startByte, condition.endByte);
          Struct trueBranch =
              Struct(type: StructType.ifCondition, primaryValue: "true");
          var bodyNode =
              Struct(type: StructType.ifStatement, primaryValue: value);
          var nodes = extractNodes(child, code);
          trueBranch.subStructs = nodes;

          var alternative = child.childByFieldName("alternative");
          if (!alternative.isNull) {
            var falseBranch =
                Struct(type: StructType.ifCondition, primaryValue: "false");
            var falseNodes = extractNodes(alternative, code);
            falseBranch.subStructs = falseNodes;
            bodyNode.subStructs = [trueBranch, falseBranch];
          } else {
            bodyNode.subStructs = [trueBranch];
          }
          structs.add(bodyNode);
          break;
        case "switch_statement":
          var condition =
              child.childByFieldName("condition").childByFieldName("value");
          var value = code.substring(condition.startByte, condition.endByte);
          Struct bodyNode =
              Struct(type: StructType.switchStatement, primaryValue: value);
          var nodes = extractNodes(child, code);
          bodyNode.subStructs = nodes;
          break;
        case "case_statement":
          var condition = child.childByFieldName("value");
          var value = "default";
          if (!condition.isNull) {
            code.substring(condition.startByte, condition.endByte);
          }
          var bodyNode =
              Struct(type: StructType.caseStatement, primaryValue: value);
          var nodes = extractNodes(child, code);
          bodyNode.subStructs = nodes;
          structs.add(bodyNode);
          break;
      }
    }
    return structs;
  }
}
