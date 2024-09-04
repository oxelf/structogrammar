
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/pages/main/main_page.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope( child:  MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      scrollBehavior:  const MaterialScrollBehavior().copyWith(
        // Mouse dragging enabled for this demo
        dragDevices: PointerDeviceKind.values.toSet(),
      ),
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
