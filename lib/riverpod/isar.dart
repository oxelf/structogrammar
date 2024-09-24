import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:structogrammar/models/download_object.dart';
import 'package:structogrammar/models/project.dart';
import 'package:structogrammar/models/struct.dart';

final isarPod = FutureProvider((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  return Isar.open(
    [
      ProjectSchema,
      StructHeadSchema,
      DownloadObjectSchema,
    ],
    directory: dir.path,
  );
});
