
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/riverpod/managers.dart';

import '../models/project.dart';

// class ProjectsNotifier extends Notifier<List<Project>> {
//   @override
//   List<Project> build() {
//     return [];
//   }
//
//   void add(Project project) {
//     state = [...state, project];
//   }
//
//   void remove(String projectId) {
//     List<Project> projects = state;
//     projects.removeWhere((e) => e.projectId == projectId);
//     state = [...projects];
//   }
//
//   void rename(String projectId, String newName) {
//     List<Project> projects = state;
//     for (int i = 0; i < projects.length; i++) {
//       if (projects[i].projectId == projectId) {
//         projects[i].projectName = newName.trim();
//       }
//     }
//     state = [...projects];
//   }
//
//   Future<void> loadProjects() async {
//     if (kIsWeb) return;
//     String dir = await getProjectsDirectory();
//     Directory projectsDirectory = Directory(dir);
//     if (!projectsDirectory.existsSync()) {
//       projectsDirectory.createSync();
//     }
//     List<Project> projects = [];
//     List<FileSystemEntity> projectEntities = projectsDirectory.listSync();
//     for (int i = 0; i < projectEntities.length; i++) {
//       projectEntities[i].stat().then((stat) {
//         if (stat.type == FileSystemEntityType.directory) {
//           Directory projectDir = Directory(projectEntities[i].path);
//           try {
//             projects.add(Project.fromPath(projectDir.path));
//           } catch (e) {
//             print("couldn't load project: $e");
//           }
//         }
//       });
//     }
//     state = projects;
//   }
// }

// final projectsPod = NotifierProvider<ProjectsNotifier, List<Project>>(() {
//   return ProjectsNotifier();
// });


final projectsPod = StreamProvider((ref) async* {
  final manager = await ref.watch(projectsManagerPod.future);
  yield* manager.watchProjects();
});

final projectPod = StreamProvider.family<Project, int>((ref, id) async* {
  final manager = await ref.watch(projectsManagerPod.future);
  yield* manager.watchProject(id);
});