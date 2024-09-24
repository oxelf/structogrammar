import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:version/version.dart';

Future<String?> checkForUpdates() async {
  if (kIsWeb) return null;
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String version = packageInfo.version;
  Version flutterVersion = Version.parse(version);
  final response = await http.get(
      Uri.parse("https://api.github.com/repos/oxelf/structogrammar/releases"));
  if (response.statusCode != 200) {
    return null;
  } else {
    List<dynamic> releases = jsonDecode(response.body);
    for (int i = 0; i < releases.length; i++) {
      Version releaseVersion = Version.parse((releases[i]["tag_name"] ?? "").toString().replaceAll("v", ""));
      if (releaseVersion > flutterVersion) {
        final response = await http.get(Uri.parse(releases[i]["assets_url"] ?? ""));
        List<dynamic> jsonAssets = jsonDecode(response.body);
        for (int j = 0; j < jsonAssets.length; j++) {
          if (jsonAssets[j]["name"].toString().endsWith(".dmg") && Platform.isMacOS) {
          return jsonAssets[j]["browser_download_url"];
          }
          if (jsonAssets[j]["name"].toString().endsWith(".exe") && Platform.isWindows) {
            return jsonAssets[j]["browser_download_url"];
          }
        }
      }
    }
  }
  return null;
}
