import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:structogrammar/models/download_object.dart';
import 'package:http/http.dart' as http;
import '../util/download_url.dart';

List<DownloadObject> dependencies = [
  DownloadObject(
    name: "tree-sitter",
    filePath: "libtree-sitter.dylib",
    hash: "a18e9dba7f09e701cbd33fb5eb6248347fad3891",
    isDownloaded: false,
  ),
  DownloadObject(
    name: "tree-sitter-cpp",
    filePath: "cpp.dylib",
    hash: "c2557356acc73d4181e3c20e0e7cec0602f6b975",
    isDownloaded: false,
  ),
  // DownloadObject(
  //   name: "dmg",
  //   filePath: " structogrammar-0.0.50+0.0.50-macos.dmg",
  //   hash: "c2557356acc73d4181e3c20e0e7cec0602f6b975",
  //   isDownloaded: false,
  // ),
];

class DownloadManager {
  const DownloadManager(this.isar);

  final Isar isar;

  Stream<List<DownloadObject>> watchDownloads() async* {
    final query = isar.downloads.where().filter().progressIsNotNull().build();

    await for (final results in query.watch(fireImmediately: true)) {
      yield results;
    }
  }

  Future<void> updateProgress(String name, double? progress) {
    return isar.writeTxn(() async {
      final downloadObject =
          await isar.downloads.where().filter().nameEqualTo(name).findFirst();
      if (downloadObject != null) {
        downloadObject.progress = progress;
        await isar.downloads.put(downloadObject);
      }
    });
  }

  Future<void> setDownloaded(String name) {
    return isar.writeTxn(() async {
      final downloadObject =
          await isar.downloads.where().filter().nameEqualTo(name).findFirst();
      if (downloadObject != null) {
        downloadObject.isDownloaded = true;
        downloadObject.progress = null;
        await isar.downloads.put(downloadObject);
      }
    });
  }

  Future<DownloadObject?> addDownload(
      String name, String filePath, String hash) async {
    List<DownloadObject?> downloads = await getDownloads();
    try {
      return downloads.firstWhere((e) => e!.name == name);
    } catch (e) {}

    final downloadObject = DownloadObject(
      name: name,
      filePath: filePath,
      hash: hash,
      isDownloaded: false,
      progress: 0.0,
    );
    await isar.writeTxn(() async {
      await isar.downloads.put(downloadObject);
    });

    DownloadObject? newDownload =
        await isar.downloads.where().filter().nameEqualTo(name).findFirst();
    return newDownload;
  }

  Future<void> download(String name) async {
    DownloadObject? dependency;
    try {
      dependency = dependencies.firstWhere((e) => e.name == name);
    } catch (e) {
      print(e);
    }

    List<DownloadObject?> downloads = await getDownloads();

    try {
      dependency = downloads
          .firstWhere((e) => e!.name == name && e.isDownloaded == true);
      return;
    } catch (e) {
      print(e);
    }

    if (dependency == null) return;

    String? downloadUrl = await getDownloadUrl(dependency.filePath);
    if (downloadUrl == null) return;

    DownloadObject? newDownload = await addDownload(
        dependency.name, dependency.filePath, dependency.hash);

    if (newDownload == null) return;

    final response =
        await http.Client().send(http.Request('GET', Uri.parse(downloadUrl)));
    final total = response.contentLength ?? 0;
    final bytes = <int>[];
    int received = 0;

    response.stream.listen((value) {
      bytes.addAll(value);
      received += value.length;
      final progress = received / total;

      updateProgress(dependency!.name, progress);
      print("progress: $progress");
    }).onDone(() async {
      final file = File(
          '${(await getApplicationDocumentsDirectory()).path}/${newDownload.filePath}');
      await file.writeAsBytes(bytes);

      setDownloaded(newDownload.name);
    });
  }

  Future<List<DownloadObject?>> getDownloads() async {
    return isar.downloads.where().findAll();
  }

  Future<void> init() async {
    List<DownloadObject?> downloads = await getDownloads();
    for (int i = 0; i < dependencies.length; i++) {
      DownloadObject? download;
      try {
        download = downloads.firstWhere((e) => e!.hash == dependencies[i].hash);
      } catch (e) {
        print(e);
      }
      File file = File(
          "${(await getApplicationDocumentsDirectory()).path}/${dependencies[i].filePath}");
      if (file.existsSync()) {
        if (download != null) {
          download.isDownloaded = true;
          isar.writeTxn(() async {
            await isar.downloads.put(download!);
          });
        } else {
          dependencies[i].isDownloaded = true;
          isar.writeTxn(() async {
            await isar.downloads.put(dependencies[i]);
          });
        }
      } else {
        if (download != null) {
          download.isDownloaded = false;
          isar.writeTxn(() async {
            await isar.downloads.put(download!);
          });
        }
      }
    }
  }
}
