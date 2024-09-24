import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:structogrammar/models/project.dart';
import 'package:structogrammar/models/struct.dart';
import 'package:toastification/toastification.dart';

import '../main.dart';

class ProjectManager {
  const ProjectManager(this.isar);

  final Isar isar;

  Stream<List<Project>> watchProjects() async* {
    final query = isar.projects.where().sortByLastEditedDesc().build();

    await for (final results in query.watch(fireImmediately: true)) {
      yield results;
    }
  }

  Stream<Project> watchProject(int projectId) async* {
    final query = isar.projects.where().idEqualTo(projectId).build();

    await for (final results in query.watch(fireImmediately: true)) {
      if (results.isNotEmpty) yield results[0];
    }
  }

  Future<int?> addProject(Project project) async {
    if (await exists(project.id)) {
      return null;
    }
    int? newProjectId;
    await isar.writeTxnSync(() async {
      newProjectId =  isar.projects.putSync(project);
    });
    // if (project.struct.value != null) {
    //   structsManager.addStruct(project.struct.value!);
    //   await isar.writeTxn(() async {
    //     await project.struct.save();
    //   });
    // }
    return newProjectId;
  }

  void updateProject(Project project) async {
    if (!(await exists(project.id))) {
      return;
    }
    isar.writeTxnSync(() {
      isar.projects.putSync(project);
    });
  }

  void deleteProject(int projectId) async {
    Project? project = getProject(projectId);
    if (project == null) return;
    int? structId = project.struct.value?.id;
    isar.writeTxnSync(() {
      isar.projects.deleteSync(projectId);
      if (structId  != null) isar.structs.deleteSync(structId);
    });
  }

  Project? getProject(int projectId) {
    return isar.projects.filter().idEqualTo(projectId).build().findFirstSync();
  }

  Future<void> updateProjectImage(int projectId, String base64Image) async {
    final project = await isar.projects.get(projectId);
    if (project == null) {
      toastification.show(
        context: navigatorKey.currentContext,
        type: ToastificationType.warning,
        style: ToastificationStyle.flat,
        title: const Text("Project not found"),
        description: const Text("The project with the given ID was not found"),
        alignment: Alignment.bottomRight,
        autoCloseDuration: const Duration(seconds: 4),
        boxShadow: lowModeShadow,
      );
      return;
    }

    project.imageData = base64Image;

    await isar.writeTxn(() async {
      await isar.projects.put(project);
    });

  }

  Future<bool> exists(int projectId) async {
    return await isar.projects.filter().idEqualTo(projectId).isNotEmpty();
  }
}
