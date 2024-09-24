import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';
import 'package:http/http.dart' as http;

Future<String?> getDownloadUrl(String asset) async {
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
      final newResponse = await http.get(Uri.parse(releases[0]["assets_url"] ?? ""));
        List<dynamic> jsonAssets = jsonDecode(newResponse.body);
        for (int j = 0; j < jsonAssets.length; j++) {
          if (jsonAssets[j]["name"].toString() == asset) {
            return jsonAssets[j]["browser_download_url"];
          }
      }

  }
  return null;
}