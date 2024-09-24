import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:structogrammar/models/project.dart';
import 'package:structogrammar/models/struct.dart';
import 'package:structogrammar/util/uuid.dart';

Future<String> getSavePath(String projectId) async {
  if (kIsWeb) return "";
  Directory dir = await getApplicationDocumentsDirectory();
  return "${dir.path}/projects/$projectId";
}

Future<String> getProjectsDirectory() async {
  if (kIsWeb) return "";
  Directory dir = await getApplicationDocumentsDirectory();
  return "${dir.path}/projects/";
}

Future<Project> createProject(String name) async {
  String id = generateUUID();
  String path = await getSavePath(id);
  Project project = Project(
      projectName: name,
      path: path,
      imageData:
          "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IiAIhkCAAAECERAEQyBAgACBCAiCIRAgQIBABATBEAgQIEAgAoJgCAQIECAQAUEwBAIECBCIgCAYAgECBAhEQBAMgQABAgQiIAiGQIAAAQIREARDIECAAIEICIIhECBAgEAEBMEQCBAgQCACgmAIBAgQIBABQTAEAgQIEIiAIBgCAQIECERAEAyBAAECBCIgCIZAgAABAhEQBEMgQIAAgQgIgiEQIECAQAQEwRAIECBAIAKCYAgECBAgEAFBMAQCBAgQiIAgGAIBAgQIREAQDIEAAQIEIiAIhkCAAAECERAEQyBAgACBCAiCIRAgQIBABATBEAgQIEAgAoJgCAQIECAQAUEwBAIECBCIgCAYAgECBAhEQBAMgQABAgQiIAiGQIAAAQIREARDIECAAIEICIIhECBAgEAEBMEQCBAgQCACgmAIBAgQIBABQTAEAgQIEIiAIBgCAQIECERAEAyBAAECBCIgCIZAgAABAhEQBEMgQIAAgQgIgiEQIECAQAQEwRAIECBAIAKCYAgECBAgEAFBMAQCBAgQiIAgGAIBAgQIREAQDIEAAQIEIiAIhkCAAAECERAEQyBAgACBCAiCIRAgQIBABATBEAgQIEAgAoJgCAQIECAQAUEwBAIECBCIgCAYAgECBAhEQBAMgQABAgQiIAiGQIAAAQIREARDIECAAIEICIIhECBAgEAEBMEQCBAgQCACgmAIBAgQIBABQTAEAgQIEIiAIBgCAQIECERAEAyBAAECBCIgCIZAgAABAhEQBEMgQIAAgQgIgiEQIECAQAQEwRAIECBAIAKCYAgECBAgEAFBMAQCBAgQiIAgGAIBAgQIREAQDIEAAQIEIiAIhkCAAAECERAEQyBAgACBCAiCIRAgQIBABATBEAgQIEAgAoJgCAQIECAQAUEwBAIECBCIgCAYAgECBAhEQBAMgQABAgQiIAiGQIAAAQIREARDIECAAIEICIIhECBAgEAEBMEQCBAgQCACgmAIBAgQIBABQTAEAgQIEIiAIBgCAQIECERAEAyBAAECBCIgCIZAgAABAhEQBEMgQIAAgQgIgiEQIECAQAQEwRAIECBAIAKCYAgECBAgEAFBMAQCBAgQiIAgGAIBAgQIREAQDIEAAQIEIiAIhkCAAAECERAEQyBAgACBCAiCIRAgQIBABATBEAgQIEAgAoJgCAQIECAQAUEw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",
      type: "structogram",
      lastEdited: DateTime.now());
  StructHead structHead = StructHead(
      type: StructType.function,
      primaryValue: "main()",
      width: 400,
      structTextStyle: StructTextStyle.functionStyle(),
      subStructs: [
        Struct(
            type: StructType.instruction,
            primaryValue: 'cout << "hello world";'),
        Struct(type: StructType.instruction, primaryValue: "new veeeeeeeerrrrrrryyyyyyy looooonnnnnggggg insssttrrrruuuuucttttiiononn"),
        Struct(type: StructType.forLoop, primaryValue: "i < 10", subStructs: [
          Struct(
              type: StructType.instruction,
              primaryValue: "instruction inside for loop"),
          Struct(
              type: StructType.instruction,
              primaryValue: "new veeeeeeeerrrrrrryyyyyyy looooonnnnnggggg insssttrrrruuuuucttttiiononn"),
        ]),
        Struct(type: StructType.whileLoop, primaryValue: "i > 10", subStructs: [
          Struct(
              type: StructType.instruction,
              primaryValue: "instruction inside while loop"),
        ]),
        Struct(type: StructType.doWhileLoop, primaryValue: "i = 10", subStructs: [
          Struct(
              type: StructType.instruction,
              primaryValue: "instruction inside do while loop"),
          Struct(
              type: StructType.instruction,
              primaryValue: "another instruction"),
        ]),
        Struct(type: StructType.ifStatement, primaryValue: "i == 0", subStructs: [
          Struct(
              type: StructType.ifCondition,
              primaryValue: "true", subStructs: [
                Struct(type: StructType.instruction, primaryValue: "inside true"),
            Struct(type: StructType.instruction, primaryValue: "new veeeeeeeerrrrrrryyyyyyy looooonnnnnggggg insssttrrrruuuuucttttiiononn"),
          ]),
          Struct(
              type: StructType.ifCondition,
              primaryValue: "false", subStructs: [
            Struct(type: StructType.instruction, primaryValue: "new veeeeeeeerrrrrrryyyyyyy looooonnnnnggggg insssttrrrruuuuucttttiiononn"),
          ]),
        ]),
        Struct(type: StructType.switchStatement, primaryValue: "i == 0", subStructs: [
          Struct(
              type: StructType.caseStatement,
              primaryValue: "1", subStructs: [
            Struct(type: StructType.instruction, primaryValue: "inside 1"),
            Struct(type: StructType.instruction, primaryValue: "inside 1 again"),
          ]),
          Struct(
              type: StructType.caseStatement,
              primaryValue: "default", subStructs: [
            Struct(type: StructType.instruction, primaryValue: "inside default"),
          ]),
        ]),
        Struct(type: StructType.tryStatement, primaryValue: "", subStructs: [
          Struct(
              type: StructType.instruction,
              primaryValue: "instruction inside try"),
          Struct(type: StructType.catchStatement, primaryValue: "const myDataFormatException& e", subStructs: [
            Struct(
                type: StructType.instruction,
                primaryValue: "instruction inside catch"),
          ])
        ]),
      ]);
  project.struct.value = structHead;
  return project;
}
