import 'dart:convert';
import 'dart:io';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:structogrammar/riverpod/translation.dart';
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
  var translations = ref.read(translationsPod);
  Map<String, dynamic> additionalData = {};
  additionalData["ifValue"] = struct.data["ifValue"];

  final entries = <ContextMenuEntry>[
    MenuItem(
      label: translations["copy"].toString(),
      icon: Icons.copy,
      onSelected: () {
        // implement copy
      },
    ),
    MenuItem(
      label: translations["paste"].toString(),
      icon: Icons.paste,
      onSelected: () {
        // implement paste
      },
    ),
    MenuItem(
      label: translations["delete"].toString(),
      icon: Icons.delete,
      onSelected: () {
        ref.read(structsPod.notifier).removeStruct(struct.id);
        // implement paste
      },
    ),

   const MenuDivider(),
    if ((struct.type == StructType.loop || struct.type == StructType.function || struct.type == StructType.repeat))
      MenuItem.submenu(
          label: translations["addInside"].toString(), icon: Icons.add, items: [MenuItem(
        label: translations["instruction"].toString(),
        value: "instruction",
        icon: Icons.integration_instructions_outlined,
        onSelected: () {
          ref.read(structsPod.notifier).addSubStruct(struct.id,
              Struct.instruction(
                  "", additionalData: additionalData));
          // implement undo
        },
      ),
        MenuItem(
          label: translations["ifStatement"].toString(),
          value: 'if',
          icon: CommunityMaterialIcons.code_parentheses,
          onSelected: () {
            ref.read(structsPod.notifier).addSubStruct(struct.id,
                Struct.ifStatement(
                    "?",trueSubStructs: [Struct.instruction("", additionalData: {"ifValue": true})], falseSubStructs: [Struct.instruction("", additionalData: {"ifValue": false})], additionalData: additionalData));
            // implement redo
          },
        ),
        MenuItem(
          label: translations["caseStatement"].toString(),
          value: 'case',
          icon: CommunityMaterialIcons.code_array,
          onSelected: () {
            // implement redo
          },
        ),
        MenuItem(
          label: translations["forLoop"].toString(),
          value: 'for',
          icon: Icons.loop_outlined,
          onSelected: () {
            ref.read(structsPod.notifier).addSubStruct(struct.id,
                Struct.loop(
                    "?","for", [Struct.instruction("")], additionalData: additionalData));
          },
        ),
        MenuItem(
          label: translations["whileLoop"].toString(),
          value: 'while',
          icon: Icons.loop_outlined,
          onSelected: () {
            ref.read(structsPod.notifier).addSubStruct(struct.id,
                Struct.loop(
                    "?","while", [Struct.instruction("")], additionalData: additionalData));
          },
        ),
        MenuItem(
          label: translations["doWhileLoop"].toString(),
          value: 'repeat',
          icon: Icons.loop_outlined,
          onSelected: () {
            ref.read(structsPod.notifier).addSubStruct(struct.id,
                Struct.until(
                    "?", [Struct.instruction("")], additionalData: additionalData));
          },
        ),
      ]),
    if (!(struct.type == StructType.function))  MenuItem.submenu(label: translations["add"].toString(), icon: Icons.add, items: [
      MenuItem.submenu(
          label: translations["before"].toString(), icon: Icons.arrow_upward, items: [MenuItem(
        label: translations["instruction"].toString(),
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
          label: translations["ifStatement"].toString(),
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
          label: translations["caseStatement"].toString(),
          value: 'case',
          icon: CommunityMaterialIcons.code_array,
          onSelected: () {
            // implement redo
          },
        ),
        MenuItem(
          label: translations["forLoop"].toString(),
          value: 'for',
          icon: Icons.loop_outlined,
          onSelected: () {
            ref.read(structsPod.notifier).addStructAfter(struct.id,
                Struct.loop(
                    "?","for", [Struct.instruction("")], additionalData: additionalData));
          },
        ),
        MenuItem(
          label:translations["whileLoop"].toString(),
          value: 'while',
          icon: Icons.loop_outlined,
          onSelected: () {
            ref.read(structsPod.notifier).addStructAfter(struct.id,
                Struct.loop(
                    "?","while", [Struct.instruction("")], additionalData: additionalData));
          },
        ),
        MenuItem(
          label: translations["doWhileLoop"].toString(),
          value: 'repeat',
          icon: Icons.loop_outlined,
          onSelected: () {
            ref.read(structsPod.notifier).addStructAfter(struct.id,
                Struct.until(
                    "?", [Struct.instruction("")], additionalData: additionalData));
          },
        ),
      ]),
      MenuItem.submenu(label: translations["after"].toString(), icon: Icons.arrow_upward, items: [
        MenuItem(
          label: translations["instruction"].toString(),
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
          label: translations["ifStatement"].toString(),
          value: 'if',
          icon: CommunityMaterialIcons.code_parentheses,
          onSelected: () {
            ref.read(structsPod.notifier).addStructAfter(struct.id,
                Struct.ifStatement(
                    "?", trueSubStructs: [Struct.instruction("", additionalData: {"ifValue": true})], falseSubStructs: [Struct.instruction("", additionalData: {"ifValue": false})], additionalData: additionalData));
          },
        ),
        MenuItem(
          label: translations["caseStatement"].toString(),
          value: 'case',
          icon: CommunityMaterialIcons.code_array,
          onSelected: () {

          },
        ),
        MenuItem(
          label: translations["forLoop"].toString(),
          value: 'for',
          icon: Icons.loop_outlined,
          onSelected: () {
            ref.read(structsPod.notifier).addStructAfter(struct.id,
                Struct.loop(
                    "?", "for", [Struct.instruction("")], additionalData: additionalData));
          },
        ),
        MenuItem(
          label: translations["whileLoop"].toString(),
          value: 'while',
          icon: Icons.loop_outlined,
          onSelected: () {
            ref.read(structsPod.notifier).addStructAfter(struct.id,
                Struct.loop(
                    "?", "while", [Struct.instruction("")], additionalData: additionalData));
          },
        ),
        MenuItem(
          label: translations["doWhileLoop"].toString(),
          value: 'repeat',
          icon: Icons.loop_outlined,
          onSelected: () {
            ref.read(structsPod.notifier).addStructAfter(struct.id,
                Struct.until(
                    "?", [Struct.instruction("")], additionalData: additionalData));
            // implement redo
          },
        ),
      ]),
    ],),
    const MenuDivider(),
    MenuItem(label: translations["exportImage"].toString(),
        icon: Icons.image,
        value: "screenshot",
        onSelected: () async {
      try {
      ref.read(selectedStructPod.notifier).state = "";} catch (_) {}
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

  if (struct.type == StructType.loop || struct.type == StructType.function || struct.type == StructType.repeat) {

  }
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

