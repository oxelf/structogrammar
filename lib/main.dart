
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/pages/main/main_page.dart';
import 'package:flutter_web_plugins/url_strategy.dart';


void main() {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope( child:  MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      scrollBehavior:  const MaterialScrollBehavior().copyWith(
        dragDevices: PointerDeviceKind.values.toSet(),
      ),
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
