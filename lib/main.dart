// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: InfiniteCanvas(),
//       ),
//     );
//   }
// }
//
// class InfiniteCanvas extends StatefulWidget {
//   @override
//   _InfiniteCanvasState createState() => _InfiniteCanvasState();
// }
//
// class _InfiniteCanvasState extends State<InfiniteCanvas> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onScaleUpdate: (ScaleUpdateDetails details) {
//         // Optional: Handle additional scaling behavior if necessary
//       },
//       child: InteractiveViewer(
//         boundaryMargin: EdgeInsets.all(double.infinity),  // Infinite boundaries
//         minScale: 0.1,  // Minimum zoom level
//         maxScale: 10.0,  // Maximum zoom level
//         child: Container(
//           color: Colors.grey[200],
//           width: 100000,  // An arbitrary large width
//           height: 100000,  // An arbitrary large height
//           child: Stack(
//             children: [
//               // Positioned(
//               //   left: 100,
//               //   top: 100,
//               //   child: DraggableItem(Colors.blue, "1"),
//               // ),
//               // Positioned(
//               //   left: 300,
//               //   top: 300,
//               //   child: DraggableItem(Colors.red, "2"),
//               // ),
//               // Add more positioned items here
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



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
    theme: ThemeData(primaryColor: Colors.blue),
    debugShowCheckedModeBanner: false,
    home: MainPage(),
  );

  }
}


