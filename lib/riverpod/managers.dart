import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/managers/download_manager.dart';
import 'package:structogrammar/managers/projects_manager.dart';
import 'package:structogrammar/managers/structs_manager.dart';

import 'isar.dart';

final projectsManagerPod = FutureProvider((ref) async {
  final isar = await ref.watch(isarPod.future);
  return ProjectManager(isar);
});

final structManagerPod = FutureProvider((ref) async {
  final isar = await ref.watch(isarPod.future);
  return StructsManager(isar);
});


final downloadManagerPod = FutureProvider((ref) async {
  final isar = await ref.watch(isarPod.future);
  return DownloadManager(isar);
});

