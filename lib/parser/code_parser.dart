import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:structogrammar/models/tree_node.dart';
import 'package:structogrammar/util/uuid.dart';

import '../models/struct.dart';

class CodeParser {
  static Future<List<Struct>> parseCppCode(String code) async {
    final result = await http.post(Uri.parse("https://structogrammar-parser.oxelf.dev/tree/cpp"), body: code);
    if (result.statusCode != 200) {
      print("code parsing failed");
      throw Exception("code parsing failed, non zero statuscode");
    }
    List<dynamic> json = jsonDecode(result.body);
    List<TreeNode> nodes = [];
    for (int i = 0; i < json.length; i++) {
      nodes.add(TreeNode.fromJson(json[i]));
    }
    List<Struct> structs = convertNodes(nodes);
    return structs;
  }

  static List<Struct> convertNodes(List<TreeNode> nodes) {
    Struct convertNode(TreeNode node) {
      Struct struct = Struct(id: generateUUID(), type: StructType.instruction, data: {}, subStructs: []);
      switch (node.type) {
        case "function":
          struct.type = StructType.function;
          struct.data["text"] = node.data;
          for (int i = 0; i < node.nodes.length; i++) {
            struct.subStructs.add(convertNode(node.nodes[i]));
          }
        case "for":
          struct.type = StructType.loop;
          struct.data["condition"] = node.condition;
          struct.data["loopType"] = "for";
          for (int i = 0; i < node.nodes.length; i++) {
            struct.subStructs.add(convertNode(node.nodes[i]));
          }
        case "while":
          struct.type = StructType.loop;
          struct.data["condition"] = node.condition;
          struct.data["loopType"] = "while";
          for (int i = 0; i < node.nodes.length; i++) {
            struct.subStructs.add(convertNode(node.nodes[i]));
          }
        case "doWhile":
          struct.type = StructType.repeat;
          //Code of death
          struct.data["condition"] = node.condition?.replaceFirst("(", "").split("").reversed.join("").replaceFirst(")", "").split("").reversed.join("");
          for (int i = 0; i < node.nodes.length; i++) {
            struct.subStructs.add(convertNode(node.nodes[i]));
          }
        case "if":
          struct.type = StructType.ifSelect;
          struct.data["condition"] = node.data;
          for (int i = 0; i < node.nodes.length; i++) {
            Struct newStruct = convertNode(node.nodes[i]);
            newStruct.data["ifCondition"] = node.nodes[i].condition;
            struct.subStructs.add(newStruct);
          }
        case "switch":
          struct.type = StructType.caseSelect;
          struct.data["condition"] = node.data;
          for (int i = 0; i < node.nodes.length; i++) {
            for (int j = 0; j < node.nodes[i].nodes.length; j++) {
              Struct newStruct = convertNode(node.nodes[i].nodes[j]);
              newStruct.data["case"] = node.nodes[i].condition.toString();
              struct.subStructs.add(newStruct);
            }
          }
        default:
          struct.data["instruction"] = node.data;
      }
      return struct;
    }
    List<Struct> structs = [];
    for (int i = 0; i < nodes.length; i++) {
      structs.add(convertNode(nodes[i]));
    }
    return structs;
  }
}