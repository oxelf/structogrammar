import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:structogrammar/models/settings.dart';



class SettingsNotifier extends Notifier<Settings> {
  @override
  Settings build() {
    return Settings(language: "en");
  }

  void setLanguage(String language) {
    Settings newSettings = Settings(language: language);
    state = newSettings;
    saveToFile();
  }

  void saveToFile() async {
    Directory dir = await getApplicationDocumentsDirectory();
    File( dir.path + "/settings.json").writeAsStringSync(jsonEncode(state.toJson()));
  }

  void loadSettings() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String jsonString = "";
    try {
     jsonString = File( dir.path + "/settings.json").readAsStringSync();} catch (e) {
      print("error loading settings: $e");
    }
    if (jsonString.isEmpty) {
      File( dir.path + "/settings.json").writeAsStringSync(jsonEncode(Settings(language: "en").toJson()));
      jsonString = File( dir.path + "/settings.json").readAsStringSync();
    }

    Settings settings = Settings.fromJson(jsonDecode(jsonString));
    state = settings;
  }
}


final settingsPod = NotifierProvider<SettingsNotifier, Settings>((){
  return SettingsNotifier();
});
