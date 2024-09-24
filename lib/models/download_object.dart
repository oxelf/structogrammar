import 'package:isar/isar.dart';

part 'download_object.g.dart';

@Collection(accessor: "downloads")
class DownloadObject {
  Id id = Isar.autoIncrement;
  String name;
  double? progress;
  String filePath;
  String hash;
  bool isDownloaded;

  DownloadObject({
    required this.name,
    this.progress,
    required this.filePath,
    required this.hash,
    required this.isDownloaded,
  });
}