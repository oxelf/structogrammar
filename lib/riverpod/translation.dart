import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/riverpod/settings.dart';



class TranslationNotifier extends Notifier<Map<String, String>> {
  @override
  Map<String, String> build() {
    return {};
  }

  void loadDefault() {
    loadTranslation("en");
  }

  Future<Map<String, dynamic>> getLanguage(String language) async {
    String content = await rootBundle.loadString("assets/translation/$language.json");
    Map<String, dynamic> translations = jsonDecode(content);
    return translations;
  }

  void loadTranslation(String locale) async {
    Map<String, String> english = state;
    if (locale != "en") {
      Map<String, dynamic> english =  await getLanguage("en");
    }
    String content = await rootBundle.loadString("assets/translation/$locale.json");
    Map<String, dynamic> translations = jsonDecode(content);
    Map<String, String> joinedMap = english;
    for (int i = 0; i < translations.length; i++) {
      joinedMap[translations.keys.toList()[i]] = translations.values.toList()[i].toString();
    }
    state = joinedMap;
  }

}




final translationsPod = NotifierProvider<TranslationNotifier, Map<String, String>>((){
  return TranslationNotifier();
});


