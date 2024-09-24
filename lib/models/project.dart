import 'dart:convert';
import 'dart:io';

import 'package:isar/isar.dart';

import 'struct.dart';

part 'project.g.dart';

enum ProjectType { structogram }

ProjectType projectTypeFromString(String type) {
  ProjectType value = ProjectType.structogram;
  ProjectType.values.forEach((e) {
    if (e.toString() == type) {
      value = e;
    }
  });
  return value;
}

@Collection(accessor: "projects")
class Project {
  Id id = Isar.autoIncrement;
  String? projectName;
  String? path;
  String? imageData;
  String? type;
  DateTime? lastEdited;
  final struct = IsarLink<StructHead>();

  Project({
    this.id = Isar.autoIncrement,
    this.projectName,
    this.path,
    this.imageData,
    this.type = "structogram",
    this.lastEdited,
  });

  Project copyWith(
      {String? projectName,
      String? path,
      String? imageData,
      String? type,
      DateTime? lastEdited,
      Id? id}) {
    Project project = Project(
      id: id ?? this.id,
      projectName: projectName ?? this.projectName,
      path: path ?? this.path,
      imageData: imageData ?? this.imageData,
      type: type ?? type,
      lastEdited: lastEdited ?? this.lastEdited,
    );
    return project;
  }

  factory Project.fromJson(Map<String, dynamic> json, DateTime lastEdited) {
    return Project(
        projectName: json["projectName"] ?? "",
        path: json["path"] ?? "",
        imageData: json["imageData"] ?? "",
        type: json["type"] ?? "",
        lastEdited: lastEdited);
  }

  factory Project.fromPath(String path) {
    Directory dir = Directory(path);
    if (!dir.existsSync()) {
      throw Exception("directory doesnt exist");
    }
    File projectFile = File("$path/project.json");
    DateTime lastEdited = DateTime.now();
    projectFile.stat().then((stat) {
      lastEdited = stat.modified;
    });
    Map<String, dynamic> projectJson =
        jsonDecode(projectFile.readAsStringSync());
    return Project.fromJson(projectJson, lastEdited);
  }
}
