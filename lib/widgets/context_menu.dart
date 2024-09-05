import 'dart:convert';
import 'dart:io';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';
import 'package:structogrammar/models/struct.dart';
import 'package:structogrammar/riverpod/state.dart';
import 'package:structogrammar/riverpod/structs.dart';
import 'package:structogrammar/widgets/struct_builder.dart';


// initialize a context menu


ContextMenu getContextMenuForStruct(Struct struct,BuildContext context, WidgetRef ref) {
  Map<String, dynamic> additionalData = {};
  additionalData["ifValue"] = struct.data["ifValue"];

  final entries = <ContextMenuEntry>[
    MenuItem(
      label: 'Copy',
      icon: Icons.copy,
      onSelected: () {
        // implement copy
      },
    ),
    MenuItem(
      label: 'Paste',
      icon: Icons.paste,
      onSelected: () {
        // implement paste
      },
    ),
    MenuItem(
      label: 'Delete',
      icon: Icons.delete,
      onSelected: () {
        ref.read(structsPod.notifier).removeStruct(struct.id);
        // implement paste
      },
    ),

    const MenuDivider(),
    MenuItem.submenu(label: "Add", icon: Icons.add, items: [
      MenuItem.submenu(
          label: "Before", icon: Icons.arrow_upward, items: [MenuItem(
        label: 'Instruction',
        value: "instruction",
        icon: Icons.integration_instructions_outlined,
        onSelected: () {
          ref.read(structsPod.notifier).addStructBefore(struct.id,
              Struct.instruction(
                  "", additionalData: additionalData));
          // implement undo
        },
      ),
        MenuItem(
          label: 'IF Statement',
          value: 'if',
          icon: CommunityMaterialIcons.code_parentheses,
          onSelected: () {
            ref.read(structsPod.notifier).addStructBefore(struct.id,
                Struct.ifStatement(
                    "?",trueSubStructs: [Struct.instruction("", additionalData: {"ifValue": true})], falseSubStructs: [Struct.instruction("", additionalData: {"ifValue": false})], additionalData: additionalData));
            // implement redo
          },
        ),
        MenuItem(
          label: 'Case Statement',
          value: 'case',
          icon: CommunityMaterialIcons.code_array,
          onSelected: () {
            // implement redo
          },
        ),
        MenuItem(
          label: 'For loop',
          value: 'for',
          icon: Icons.loop_outlined,
          onSelected: () {
            ref.read(structsPod.notifier).addStructAfter(struct.id,
                Struct.loop(
                    "?","for", [Struct.instruction("")], additionalData: additionalData));
          },
        ),
        MenuItem(
          label: 'WHILE loop',
          value: 'while',
          icon: Icons.loop_outlined,
          onSelected: () {
            ref.read(structsPod.notifier).addStructAfter(struct.id,
                Struct.loop(
                    "?","while", [Struct.instruction("")], additionalData: additionalData));
          },
        ),
        MenuItem(
          label: 'Do While loop',
          value: 'repeat',
          icon: Icons.loop_outlined,
          onSelected: () {
            ref.read(structsPod.notifier).addStructAfter(struct.id,
                Struct.until(
                    "?", [Struct.instruction("")], additionalData: additionalData));
          },
        ),
        // MenuItem(
        //   label: 'ENDLESS loop',
        //   value: 'endless',
        //   icon: Icons.loop_outlined,
        //   onSelected: () {
        //     // implement redo
        //   },
        // ),
        // MenuItem(
        //   label: 'Call',
        //   value: 'call',
        //   icon: Icons.loop_outlined,
        //   onSelected: () {
        //     // implement redo
        //   },
        // ),
        // MenuItem(
        //   label: 'Exit',
        //   value: 'exit',
        //   icon: Icons.loop_outlined,
        //   onSelected: () {
        //     // implement redo
        //   },
        // ),
        // MenuItem(
        //   label: 'Parrallel',
        //   value: 'parrallel',
        //   icon: Icons.loop_outlined,
        //   onSelected: () {
        //     // implement redo
        //   },
        // ),
        // MenuItem(
        //   label: 'Try',
        //   value: 'for',
        //   icon: Icons.loop_outlined,
        //   onSelected: () {
        //     // implement redo
        //   },
        // ),
      ]),
      MenuItem.submenu(label: "After", icon: Icons.arrow_upward, items: [
        MenuItem(
          label: 'Instruction',
          value: "instruction",
          icon: Icons.integration_instructions_outlined,
          onSelected: () {
            ref.read(structsPod.notifier).addStructAfter(struct.id,
                Struct.instruction(
                    "", additionalData: additionalData));
            // implement undo
          },
        ),
        MenuItem(
          label: 'IF Statement',
          value: 'if',
          icon: CommunityMaterialIcons.code_parentheses,
          onSelected: () {
            ref.read(structsPod.notifier).addStructAfter(struct.id,
                Struct.ifStatement(
                    "?", trueSubStructs: [Struct.instruction("", additionalData: {"ifValue": true})], falseSubStructs: [Struct.instruction("", additionalData: {"ifValue": false})], additionalData: additionalData));
          },
        ),
        MenuItem(
          label: 'Case Statement',
          value: 'case',
          icon: CommunityMaterialIcons.code_array,
          onSelected: () {

          },
        ),
        MenuItem(
          label: 'For loop',
          value: 'for',
          icon: Icons.loop_outlined,
          onSelected: () {
            ref.read(structsPod.notifier).addStructAfter(struct.id,
                Struct.loop(
                    "?", "for", [Struct.instruction("")], additionalData: additionalData));
          },
        ),
        MenuItem(
          label: 'WHILE loop',
          value: 'while',
          icon: Icons.loop_outlined,
          onSelected: () {
            ref.read(structsPod.notifier).addStructAfter(struct.id,
                Struct.loop(
                    "?", "while", [Struct.instruction("")], additionalData: additionalData));
          },
        ),
        MenuItem(
          label: 'Do While loop',
          value: 'repeat',
          icon: Icons.loop_outlined,
          onSelected: () {
            ref.read(structsPod.notifier).addStructAfter(struct.id,
                Struct.until(
                    "?", [Struct.instruction("")], additionalData: additionalData));
            // implement redo
          },
        ),
        // MenuItem(
        //   label: 'Parrallel',
        //   value: 'parrallel',
        //   icon: Icons.loop_outlined,
        //   onSelected: () {
        //     // implement redo
        //   },
        // ),
        // MenuItem(
        //   label: 'Try',
        //   value: 'for',
        //   icon: Icons.loop_outlined,
        //   onSelected: () {
        //     // implement redo
        //   },
        // ),

      ]),
    ],),
    const MenuDivider(),
    MenuItem(label: "screenshot",
        icon: Icons.image,
        value: "screenshot",
        onSelected: () async {
      ref.read(selectedStructPod.notifier).state = "";
      Struct? rootStruct = ref.read(structsPod.notifier).findRootStruct(struct.id);
      if (rootStruct == null) {
        return;
      }
      final container = ProviderScope.containerOf(context);
      ScreenshotController screenShotController = ScreenshotController();
          Uint8List? bytes = await screenShotController.captureFromLongWidget(pixelRatio: 4, UncontrolledProviderScope(container: container, child: MediaQuery(data: MediaQueryData(), child: MaterialApp(debugShowCheckedModeBanner: false, theme: ThemeData(textTheme: TextTheme()), home: Material(textStyle: TextStyle(color: Colors.black), child: StructBuilder(struct: rootStruct, screenshot: true, maxWidth: 400,))))));
          String fileName = (ref.read(structsPod.notifier).findRootStruct(struct.id)?.data["name"] ?? "main") + ".png";

          if (kIsWeb) {
            download(bytes, downloadName: fileName);
            return;
          }

          String? outputFile = await FilePicker.platform.saveFile(
            bytes: bytes,
            dialogTitle: 'Please select where to store the screenshot:',
            fileName: fileName,
          );

          if (outputFile == null) {
            // User canceled the picker
          } else {
            File(outputFile).writeAsBytesSync(bytes);
          }

          ref.read(selectedStructPod.notifier).state = struct.id;
        }),
  ];
  return ContextMenu(
    entries: entries,
    padding: const EdgeInsets.all(8.0),
  );
}


void download(Uint8List bytes, {required String downloadName}) {

  final base64 = base64Encode(bytes);

  final anchor = html.AnchorElement(href: 'data:image/png;base64,$base64')..target = 'blank';

  anchor.download = downloadName;

  html.document.body?.append(anchor);

  anchor.click();

  anchor.remove();

}

