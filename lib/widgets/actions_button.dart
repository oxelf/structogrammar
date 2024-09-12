import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/context_extension.dart';
import 'package:structogrammar/main.dart';
import 'package:structogrammar/models/struct.dart';
import 'package:structogrammar/parser/code_parser.dart';

import '../riverpod/code_notifier.dart';
import '../riverpod/structs.dart';
import 'context_menu.dart';

class ActionsButton extends ConsumerStatefulWidget {
  const ActionsButton({super.key});

  @override
  ConsumerState createState() => _ActionsButtonState();
}

class _ActionsButtonState extends ConsumerState<ActionsButton> {
  GlobalKey buttonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: buttonKey,
      onPressed: () {
        final box = buttonKey.currentContext?.findRenderObject() as RenderBox?;
        if (box == null) return;
        Offset pos = box.localToGlobal(Offset(box.size.width, 0));
        showContextMenu(context,
            contextMenu: ContextMenu(position: pos, entries: [
              MenuItem(
                label: context.l.newFile,
                icon: Icons.add,
              ),
              MenuItem(
                  label: context.l.save,
                  icon: Icons.save,
                  onSelected: () async {
                    Uint8List bytes = Uint8List.fromList(jsonEncode(
                            ref.read(structsPod.notifier).structsToJson())
                        .codeUnits);
                    if (kIsWeb) {
                      download(bytes, downloadName: "structogram.json");
                      return;
                    }
                    String? outputFile = await FilePicker.platform.saveFile(
                      bytes: bytes,
                      dialogTitle: '',
                      fileName: "structogram.json",
                    );

                    if (outputFile == null) {
                      // User canceled the picker
                    } else {
                      File(outputFile).writeAsBytesSync(bytes);
                    }
                  }),
              MenuItem(
                  label: context.l.import,
                  icon: Icons.import_export,
                  onSelected: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();
                    if (result == null) {
                      return;
                    } else {
                      File file = File(result.files.first.path ?? "");
                      String data = file.readAsStringSync();
                      List<dynamic> json = jsonDecode(data);
                      ref.read(structsPod.notifier).structsFromJson(json);
                    }
                  }),
              MenuItem(
                  label: context.l.importFromCode,
                  icon: Icons.code,
                  onSelected: () async {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(
                            allowedExtensions: ["cpp"], type: FileType.custom);
                    if (result == null) {
                      return;
                    } else {
                      String data = "";
                      if (kIsWeb) {
                        data = utf8
                            .decode(result.files.first.bytes?.toList() ?? []);
                      } else {
                        File file = File(result.files.first.path ?? "");
                        data = file.readAsStringSync();
                      }

                      List<Struct> parsed = await CodeParser.parseCppCode(data);
                      if (parsed.isEmpty) {
                        return;
                      }
                      if (navigatorKey.currentContext == null || parsed.length == 1) {
                        ref
                            .read(structsPod.notifier)
                            .replaceStructs([parsed.first]);
                        ref.read(codePod.notifier).generate(parsed[0]);
                      } else {
                        String selectedStruct = parsed[0].id;
                        showDialog(
                            context: navigatorKey.currentContext!,
                            builder: (context) =>
                                StatefulBuilder(builder: (context, setState) {
                                  return Dialog(
                                    shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "which function do you want to import?",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                        ),
                                        for (int i = 0; i < parsed.length; i++)
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedStruct = parsed[i].id;
                                                });
                                              },
                                              child: Container(
                                                width: 300,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: (selectedStruct ==
                                                            parsed[i].id)
                                                        ? Colors.blue.shade400
                                                        : Colors.black,
                                                  ),
                                                ),
                                                child:
                                                    Center(child: Text(parsed[i].data["text"])),
                                              ),
                                            ),
                                          ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(navigatorKey.currentContext!);
                                                  ref
                                                      .read(structsPod.notifier)
                                                      .replaceStructs([
                                                    parsed.firstWhere(
                                                        (e) => e.id == selectedStruct)
                                                  ]);
                                                  ref.read(codePod.notifier).generate(
                                                      parsed.firstWhere((e) =>
                                                          e.id == selectedStruct));

                                                },
                                                child: Text(context.l.import, style: TextStyle(color: Colors.white),),
                                                style: ButtonStyle(
                                                  backgroundColor: WidgetStatePropertyAll(Colors.blue.shade400),
                                                  fixedSize: WidgetStatePropertyAll(Size(150, 40)),
                                                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }));
                      }
                    }
                  }),
            ]));
      },
      icon: Icon(Icons.menu),
    );
  }
}
