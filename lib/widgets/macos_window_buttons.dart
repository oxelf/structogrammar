import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:structogrammar/main.dart';

final buttonColors = WindowButtonColors(
    iconNormal: const Color(0xFF805306),
    mouseOver: const Color(0xFFF6A00C),
    mouseDown: const Color(0xFF805306),
    iconMouseOver: const Color(0xFF805306),
    iconMouseDown: const Color(0xFFFFD500));

Color macosCloseButtonColor = const Color(0xFFD32F2F);
Color macosMinimizeButtonColor = const Color(0xFFF6A00C);

final closeButton = WindowButtonColors(
    mouseOver: const Color(0xFFD32F2F),
    mouseDown: const Color(0xFFB71C1C),
    iconNormal: const Color(0xFF805306),
    iconMouseOver: Colors.white);


bool windowMaximized = false;

class MacosWindowButtons extends StatefulWidget {
  const MacosWindowButtons({super.key});

  @override
  State<MacosWindowButtons> createState() => _MacosWindowButtonsState();
}

class _MacosWindowButtonsState extends State<MacosWindowButtons> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 60, height: 15,);
    // return MouseRegion(
    //   onHover: (_) {
    //     setState(() {
    //       hovered = true;
    //     });
    //   },
    //   onExit: (_) {
    //     setState(() {
    //       hovered = false;
    //     });
    //   },
    //   child: SizedBox(
    //     width: 70,
    //     height: 15,
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         GestureDetector(
    //           onTap: () {
    //             appWindow.close();
    //           },
    //           child: Container(
    //               width: 15,
    //               height: 15,
    //               decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.circular(20),
    //                   color: Colors.redAccent),
    //               child: hovered
    //                   ? Center(
    //                       child: Icon(
    //                       Icons.close,
    //                       size: 10,
    //                       color: Colors.grey.shade700,
    //                     ))
    //                   : null),
    //         ),
    //         SizedBox(
    //           width: 8,
    //         ),
    //         GestureDetector(
    //           onTap: () {
    //             appWindow.minimize();
    //           },
    //           child: Container(
    //             width: 15,
    //             height: 15,
    //             decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.circular(20),
    //                 color: macosMinimizeButtonColor),
    //             child: hovered
    //                 ? Center(
    //                     child: Icon(
    //                     Icons.remove,
    //                     size: 10,
    //                     color: Colors.grey.shade700,
    //                   ))
    //                 : null,
    //           ),
    //         ),
    //         SizedBox(
    //           width: 8,
    //         ),
    //         GestureDetector(
    //           onTap: () {
    //             if (windowMaximized) {
    //               appWindow.size = initialSize;
    //               windowMaximized = false;
    //             } else {
    //               appWindow.maximize();
    //               windowMaximized = true;
    //             }
    //           },
    //           child: Container(
    //               width: 15,
    //               height: 15,
    //               decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.circular(20),
    //                   color: Colors.green),
    //               child: hovered
    //                   ? Center(
    //                       child: Icon(
    //                       CupertinoIcons.fullscreen,
    //                       size: 10,
    //                       color: Colors.grey.shade700,
    //                     ))
    //                   : null),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
