import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension ContextExtension on BuildContext {
  AppLocalizations get l => AppLocalizations.of(this)!;
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
  Orientation get orientation => MediaQuery.of(this).orientation;
  ThemeData get t => Theme.of(this);
  String get locale => Localizations.localeOf(this).languageCode;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  String os() {
    if (kIsWeb) return "web";
    if (Platform.isAndroid) return "android";
    if (Platform.isIOS) return "ios";
    return "web";
  }
}
