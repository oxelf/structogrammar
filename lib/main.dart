import 'dart:io';
import 'dart:isolate';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/managers/structs_manager.dart';
import 'package:structogrammar/pages/main/main_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:structogrammar/parser/cpp_parser.dart';
import 'package:toastification/toastification.dart';

import 'bootstrap.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey();
const initialSize = Size(1100, 800);

late StructsManager globalStructManager;
CppParser cppParser = CppParser();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  runApp( UncontrolledProviderScope(
      container: await appBootstrap(),
    child: MainApp(),
  ),);
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    doWhenWindowReady(() {
      appWindow.minSize = initialSize;
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.center;
      appWindow.restore();
      appWindow.show();
    });
  }
  cppParser.init();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  ToastificationWrapper(
      child: MaterialApp(
        navigatorKey: navigatorKey,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: PointerDeviceKind.values.toSet(),
        ),
        theme: ThemeData(primaryColor: Colors.blue),
        debugShowCheckedModeBanner: false,
        home: const MainPage(),
      ),
    );
  }
}
