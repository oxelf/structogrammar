import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';

import '../main.dart';

Future<Uint8List?> screenshotWidget(Widget widget) async {
  if (navigatorKey.currentContext == null) {
    return null;
  }
  final container = ProviderScope.containerOf(navigatorKey.currentContext!);
  ScreenshotController screenShotController = ScreenshotController();
  Uint8List? bytes = await screenShotController.captureFromLongWidget(
    pixelRatio: 5,
    UncontrolledProviderScope(
      container: container,
      child: MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(textTheme: TextTheme()),
          home: Material(
              textStyle: TextStyle(color: Colors.black), child: widget),
        ),
      ),
    ),
  );
  return bytes;
}
