
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/pages/main/main_page.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:structogrammar/riverpod/settings.dart';
import 'package:structogrammar/riverpod/translation.dart';


void main() {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope( child:  MainApp()));
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(settingsPod.notifier).loadSettings();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {return  MaterialApp(
    scrollBehavior:  const MaterialScrollBehavior().copyWith(
      dragDevices: PointerDeviceKind.values.toSet(),
    ),
    debugShowCheckedModeBanner: false,
    home: MainPage(),
  );

  }
}


