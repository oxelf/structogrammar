import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:structogrammar/models/struct.dart';
import 'package:tree_sitter/tree_sitter.dart';
import 'package:path/path.dart' as path;

String treeSitterLibName = (Platform.isMacOS)? "libtree-sitter.dylib": "libtree-sitter.so";
String cppLibName = (Platform.isMacOS)? "cpp.dylib": "cpp.so";

class CppParser {
  late Parser _parser;

  void init() async {
    String treeSitterPath = path.join(
      (await getApplicationDocumentsDirectory()).path,
       treeSitterLibName);
    String cppPath = path.join(
        (await getApplicationDocumentsDirectory()).path,
        cppLibName);
    if (!File(treeSitterPath).existsSync()) {
      rootBundle.load("assets/libs/$treeSitterLibName").then((data) {
        File(treeSitterPath).writeAsBytesSync(data.buffer.asUint8List());
      });
    }
    if (!File(cppPath).existsSync()) {
      rootBundle.load("assets/libs/$cppLibName").then((data) {
        File(cppPath).writeAsBytesSync(data.buffer.asUint8List());
      });
    }
    TreeSitterConfig.setLibraryPath(treeSitterPath);
    _parser = Parser(
        sharedLibrary: 'Documents/$cppLibName', entryPoint: 'tree_sitter_cpp');
  }

  List<Struct> parseTree(String sourceCode) {
    DateTime startTime = DateTime.now();
    final tree = _parser.parse(sourceCode);
    TSNode rootNode = tree.root;
    List<String> lines = sourceCode.split("\n");
    List<Struct> functionNodes = findFunctionNodes(rootNode, lines);
    DateTime endTime = DateTime.now();
    print(
        "parsing took ${endTime.difference(startTime).inMilliseconds}ms, parsed: ${functionNodes.map((e) => e.primaryValue).toList().join(", ")}");
    return functionNodes;
  }

  Struct parseFunctionNode(TSNode functionNode, List<String> lines) {
    TSNode functionNameNode = functionNode.childByFieldName("declarator");
    dynamic startingColumn = functionNameNode.startPoint.column;
    dynamic endingColumn = functionNameNode.endPoint.column;
    dynamic startingRow = functionNameNode.startPoint.row;
    dynamic endingRow = functionNameNode.endPoint.row;
    String functionName = lines.getFromPoints(
        functionNameNode.startPoint, functionNameNode.endPoint);
    return Struct(
        type: StructType.function,
        primaryValue: functionName,
        structTextStyle: StructTextStyle.functionStyle());
  }

  List<Struct> findFunctionNodes(TSNode node, List<String> lines) {
    List<Struct> functionStructs = [];
    if (node.nodeType == "function_definition") {
      Struct struct = parseFunctionNode(node, lines);
      List<Struct> subStructs = [];
      subStructs.addAll(extractNodes(node.childByFieldName("body"), lines));
      struct.subStructs = subStructs;
      functionStructs.add(struct);
    }
    for (int i = 0; i < node.namedChildCount; i++) {
      var child = node.namedChild(i);
      functionStructs.addAll(findFunctionNodes(child, lines));
    }
    return functionStructs;
  }

  List<Struct> extractNodes(TSNode node, List<String> lines) {
    List<Struct> structs = [];
    for (int i = 0; i < node.namedChildCount; i++) {
      var child = node.namedChild(i);
      if (child.isNull) {
        continue;
      }
      switch (child.nodeType) {
        case "compound_statement":
          var nodes = extractNodes(child, lines);
          structs.addAll(nodes);
          break;
        case "return_statement":
          var bodyNode = Struct(
              primaryValue: lines.getFromPoints(child.startPoint, child.endPoint));
          structs.add(bodyNode);
          break;
        case "expression_statement":
          var bodyNode = Struct(
              primaryValue: lines.getFromPoints(child.startPoint, child.endPoint));
          structs.add(bodyNode);
          break;
        case "declaration":
          var bodyNode = Struct(
              primaryValue: lines.getFromPoints(child.startPoint, child.endPoint));
          structs.add(bodyNode);
          break;
        case "for_statement":
          TSNode declaration = child.childByFieldName("initializer");
          TSNode condition = child.childByFieldName("condition");
          TSNode update = child.childByFieldName("update");
          String value = "";
          if (!declaration.isNull && !update.isNull) {
            value = lines.getFromPoints(declaration.startPoint, update.endPoint);
          }
          if (!declaration.isNull && update.isNull && !condition.isNull) {
            value = lines.getFromPoints(declaration.startPoint, condition.endPoint);
          }
          if (declaration.isNull && !update.isNull) {
            value = lines.getFromPoints(condition.startPoint, update.endPoint);
          }
          var bodyNode = Struct(type: StructType.forLoop, primaryValue: value);
          var nodes = extractNodes(child.childByFieldName("body"), lines);
          bodyNode.subStructs = nodes;
          structs.add(bodyNode);
          break;
        case "while_statement":
          TSNode condition = child.childByFieldName("condition");
          String value = "?";
          if (!condition.isNull) {
            value = lines.getFromPoints(condition.startPoint, condition.endPoint);
          }
          var bodyNode =
              Struct(type: StructType.whileLoop, primaryValue: value);
          var nodes = extractNodes(child.childByFieldName("body"), lines);
          bodyNode.subStructs = nodes;
          structs.add(bodyNode);
          break;
        case "do_statement":
          TSNode condition = child.childByFieldName("condition");
          String value = "?";
          if (!condition.isNull) {
            value = lines.getFromPoints(condition.startPoint, condition.endPoint);
          }
          var bodyNode =
              Struct(type: StructType.doWhileLoop, primaryValue: value);
          var nodes = extractNodes(child.childByFieldName("body"), lines);
          bodyNode.subStructs = nodes;
          structs.add(bodyNode);
          break;
        case "if_statement":
          var condition =
              child.childByFieldName("condition").childByFieldName("value");
          var value = lines.getFromPoints(condition.startPoint, condition.endPoint);
          Struct trueBranch =
              Struct(type: StructType.ifCondition, primaryValue: "true");
          var bodyNode =
              Struct(type: StructType.ifStatement, primaryValue: value);
          var nodes = extractNodes(child, lines);
          trueBranch.subStructs = nodes;

          var alternative = child.childByFieldName("alternative");
          if (!alternative.isNull) {
            var falseBranch =
                Struct(type: StructType.ifCondition, primaryValue: "false");
            var falseNodes = extractNodes(alternative, lines);
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
          var value = lines.getFromPoints(condition.startPoint, condition.endPoint);
          Struct bodyNode =
              Struct(type: StructType.switchStatement, primaryValue: value);
          var nodes = extractNodes(child, lines);
          bodyNode.subStructs = nodes;
          break;
        case "case_statement":
          var condition = child.childByFieldName("value");
          var value = "default";
          if (!condition.isNull) {
            lines.getFromPoints(condition.startPoint, condition.endPoint);
          }
          var bodyNode =
              Struct(type: StructType.caseStatement, primaryValue: value);
          var nodes = extractNodes(child, lines);
          bodyNode.subStructs = nodes;
          structs.add(bodyNode);
          break;
      }
    }
    return structs;
  }
}

extension StringListExtension  on List<String> {
  String getFromPoints(TSPoint start, TSPoint end) {
    int startRow = start.row;
    int startColumn = start.column;
    int endRow = end.row;
    int endColumn = end.column;
    if (startRow == 281) {
      print("hold on");
    }
    try {
      String result = "";
      int endRow = end.row;
      for (int i = start.row; i <= end.row; i++) {
        if (i == start.row) {
          if (i == end.row && end.column < this[i].length) {
            print("length: ${this[i].length}");
            result += this[i].substring(start.column, end.column);
          } else {
            result += this[i].substring(start.column);
          }
        } else if (i == end.row) {
          result += this[i].substring(0, end.column);
        } else {
          result += this[i];
        }
      }
      return result;
    } catch (e) {
      return "";
    }

  }
}