import 'dart:convert';
import 'dart:io';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:structogrammar/context_extension.dart';
import 'package:structogrammar/main.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';
import 'package:structogrammar/models/struct.dart';
import 'package:structogrammar/riverpod/state.dart';
import 'package:structogrammar/riverpod/structs.dart';
import 'package:structogrammar/widgets/struct_builder.dart';


ContextMenu getContextMenuForStruct(
    Struct struct, WidgetRef ref) {
  if (navigatorKey.currentContext == null) {
    throw Exception("");
  }
  BuildContext context = navigatorKey.currentContext!;
  Map<String, dynamic> additionalData = {};
  if (struct.data["condition"] != null)
  additionalData["condition"] = struct.data["condition"];
  if (struct.data["ifCondition"] != null) additionalData["ifCondition"] = struct.data["ifCondition"];
  if (struct.data["case"] != null) additionalData["case"] = struct.data["case"];

  final entries = <ContextMenuEntry>[
    MenuItem(
      label:  context.l.copy,
      icon: Icons.copy,
      onSelected: () {
        // implement copy
      },
    ),
    MenuItem(
      label: context.l.paste,
      icon: Icons.paste,
      onSelected: () {
        // implement paste
      },
    ),
    MenuItem(
      label: context.l.delete,
      icon: Icons.delete,
      onSelected: () {
        ref.read(structsPod.notifier).removeStruct(struct.id);
        // implement paste
      },
    ),
    const MenuDivider(),
    if ((struct.type == StructType.loop ||
        struct.type == StructType.function ||
        struct.type == StructType.repeat))
      MenuItem.submenu(
          label: context.l.addInside,
          icon: Icons.add,
          items: [
            MenuItem(
              label: context.l.instruction,
              value: "instruction",
              icon: Icons.integration_instructions_outlined,
              onSelected: () {
                ref.read(structsPod.notifier).addSubStruct(struct.id,
                    Struct.instruction("", additionalData: additionalData));
                // implement undo
              },
            ),
            MenuItem(
              label: context.l.ifSelect,
              value: 'if',
              icon: CommunityMaterialIcons.code_parentheses,
              onSelected: () {
                ref.read(structsPod.notifier).addSubStruct(
                    struct.id,
                    Struct.ifStatement("?",
                        trueSubStructs: [
                          Struct.instruction("",
                              additionalData: {"ifCondition": "true"})
                        ],
                        falseSubStructs: [
                          Struct.instruction("",
                              additionalData: {"ifCondition": "false"})
                        ],
                        additionalData: additionalData));
                // implement redo
              },
            ),
            MenuItem(
              label: context.l.caseStatement,
              value: 'case',
              icon: CommunityMaterialIcons.code_array,
              onSelected: () {
                // implement redo
              },
            ),
            MenuItem(
              label: context.l.forLoop,
              value: 'for',
              icon: Icons.loop_outlined,
              onSelected: () {
                ref.read(structsPod.notifier).addSubStruct(
                    struct.id,
                    Struct.loop("?", "for", [Struct.instruction("")],
                        additionalData: additionalData));
              },
            ),
            MenuItem(
              label: context.l.whileLoop,
              value: 'while',
              icon: Icons.loop_outlined,
              onSelected: () {
                ref.read(structsPod.notifier).addSubStruct(
                    struct.id,
                    Struct.loop("?", "while", [Struct.instruction("")],
                        additionalData: additionalData));
              },
            ),
            MenuItem(
              label: context.l.repeat,
              value: 'repeat',
              icon: Icons.loop_outlined,
              onSelected: () {
                ref.read(structsPod.notifier).addSubStruct(
                    struct.id,
                    Struct.until("?", [Struct.instruction("")],
                        additionalData: additionalData));
              },
            ),
          ]),
    if (!(struct.type == StructType.function))
      MenuItem.submenu(
        label: context.l.add,
        icon: Icons.add,
        items: [
          MenuItem.submenu(
              label: context.l.before,
              icon: Icons.arrow_upward,
              items: [
                MenuItem(
                  label: context.l.instruction,
                  value: "instruction",
                  icon: Icons.integration_instructions_outlined,
                  onSelected: () {
                    ref.read(structsPod.notifier).addStructBefore(struct.id,
                        Struct.instruction("", additionalData: additionalData));
                    // implement undo
                  },
                ),
                MenuItem(
                  label: context.l.ifSelect,
                  value: 'if',
                  icon: CommunityMaterialIcons.code_parentheses,
                  onSelected: () {
                    ref.read(structsPod.notifier).addStructBefore(
                        struct.id,
                        Struct.ifStatement("?",
                            trueSubStructs: [
                              Struct.instruction("",
                                  additionalData: {"ifCondition": "true"})
                            ],
                            falseSubStructs: [
                              Struct.instruction("",
                                  additionalData: {"ifCondition": "false"})
                            ],
                            additionalData: additionalData));
                    // implement redo
                  },
                ),
                MenuItem(
                  label: context.l.caseStatement,
                  value: 'case',
                  icon: CommunityMaterialIcons.code_array,
                  onSelected: () {
                    ref.read(structsPod.notifier).addStructAfter(
                        struct.id,
                        Struct.caseStatement("?",
                            additionalData: additionalData,
                            subStructs: [
                              Struct.instruction("1",
                                  additionalData: {"case": "1"}),
                              Struct.instruction("2", additionalData: {"case": "2"}),
                              Struct.instruction("3", additionalData: {"case": "3"}),
                              Struct.instruction("default", additionalData: {"case": "default"})
                            ]));
                  },
                ),
                MenuItem(
                  label: context.l.forLoop,
                  value: 'for',
                  icon: Icons.loop_outlined,
                  onSelected: () {
                    ref.read(structsPod.notifier).addStructAfter(
                        struct.id,
                        Struct.loop("?", "for", [Struct.instruction("")],
                            additionalData: additionalData));
                  },
                ),
                MenuItem(
                  label: context.l.whileLoop,
                  value: 'while',
                  icon: Icons.loop_outlined,
                  onSelected: () {
                    ref.read(structsPod.notifier).addStructAfter(
                        struct.id,
                        Struct.loop("?", "while", [Struct.instruction("")],
                            additionalData: additionalData));
                  },
                ),
                MenuItem(
                  label: context.l.doWhileLoop,
                  value: 'repeat',
                  icon: Icons.loop_outlined,
                  onSelected: () {
                    ref.read(structsPod.notifier).addStructAfter(
                        struct.id,
                        Struct.until("?", [Struct.instruction("")],
                            additionalData: additionalData));
                  },
                ),
              ]),
          MenuItem.submenu(
              label: context.l.after,
              icon: Icons.arrow_downward,
              items: [
                MenuItem(
                  label: context.l.instruction,
                  value: "instruction",
                  icon: Icons.integration_instructions_outlined,
                  onSelected: () {
                    ref.read(structsPod.notifier).addStructAfter(struct.id,
                        Struct.instruction("", additionalData: additionalData));
                    // implement undo
                  },
                ),
                MenuItem(
                  label: context.l.ifSelect,
                  value: 'if',
                  icon: CommunityMaterialIcons.code_parentheses,
                  onSelected: () {
                    ref.read(structsPod.notifier).addStructAfter(
                        struct.id,
                        Struct.ifStatement("?",
                            trueSubStructs: [
                              Struct.instruction("",
                                  additionalData: {"ifCondition": "true"})
                            ],
                            falseSubStructs: [
                              Struct.instruction("",
                                  additionalData: {"ifCondition": "false"})
                            ],
                            additionalData: additionalData));
                  },
                ),
                MenuItem(
                  label: context.l.caseStatement,
                  value: 'case',
                  icon: CommunityMaterialIcons.code_array,
                  onSelected: () {
                    ref.read(structsPod.notifier).addStructAfter(
                        struct.id,
                        Struct.caseStatement("?",
                            additionalData: additionalData,
                            subStructs: [
                              Struct.instruction("1",
                                  additionalData: {"case": "1"}),
                              Struct.instruction("2", additionalData: {"case": "2"}),
                              Struct.instruction("default", additionalData: {"case": "default"})
                            ]));
                  },
                ),
                MenuItem(
                  label: context.l.forLoop,
                  value: 'for',
                  icon: Icons.loop_outlined,
                  onSelected: () {
                    ref.read(structsPod.notifier).addStructAfter(
                        struct.id,
                        Struct.loop("?", "for", [Struct.instruction("")],
                            additionalData: additionalData));
                  },
                ),
                MenuItem(
                  label: context.l.whileLoop,
                  value: 'while',
                  icon: Icons.loop_outlined,
                  onSelected: () {
                    ref.read(structsPod.notifier).addStructAfter(
                        struct.id,
                        Struct.loop("?", "while", [Struct.instruction("")],
                            additionalData: additionalData));
                  },
                ),
                MenuItem(
                  label: context.l.doWhileLoop,
                  value: 'repeat',
                  icon: Icons.loop_outlined,
                  onSelected: () {
                    ref.read(structsPod.notifier).addStructAfter(
                        struct.id,
                        Struct.until("?", [Struct.instruction("")],
                            additionalData: additionalData));
                    // implement redo
                  },
                ),
              ]),
        ],
      ),
    const MenuDivider(),
    MenuItem(
        label: context.l.exportImage,
        icon: Icons.image,
        value: "screenshot",
        onSelected: () async {
          String fileName = (ref
              .read(structsPod.notifier)
              .findRootStruct(struct.id)
              ?.data["name"] ??
              "main") +
              ".png";
          try {
            ref.read(selectedStructPod.notifier).state = "";
          } catch (_) {}
          Struct? rootStruct =
              ref.read(structsPod.notifier).findRootStruct(struct.id);
          if (rootStruct == null) {
            return;
          }
          final container = ProviderScope.containerOf(context);
          ScreenshotController screenShotController = ScreenshotController();
         double maxWidth = double.tryParse(rootStruct.data["size"]) ?? 400;
          Uint8List? bytes = await screenShotController.captureFromLongWidget(
              pixelRatio: 4,
              UncontrolledProviderScope(
                  container: container,
                  child: MediaQuery(
                      data: MediaQueryData(),
                      child: MaterialApp(
                          debugShowCheckedModeBanner: false,
                          theme: ThemeData(textTheme: TextTheme()),
                          home: Material(
                              textStyle: TextStyle(color: Colors.black),
                              child: StructBuilder(
                                struct: rootStruct,
                                screenshot: true,
                                maxWidth: maxWidth,
                              ))))));


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

  if (struct.type == StructType.loop ||
      struct.type == StructType.function ||
      struct.type == StructType.repeat) {}
  return ContextMenu(
    entries: entries,
    padding: const EdgeInsets.all(8.0),
  );
}

void download(Uint8List bytes, {required String downloadName}) {
  final base64 = base64Encode(bytes);

  final anchor = html.AnchorElement(href: 'data:image/png;base64,$base64')
    ..target = 'blank';

  anchor.download = downloadName;

  html.document.body?.append(anchor);

  anchor.click();

  anchor.remove();
}
