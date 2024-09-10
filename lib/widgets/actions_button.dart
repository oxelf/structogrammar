import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/riverpod/translation.dart';

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
    var translations = ref.watch(translationsPod);
    return IconButton(key: buttonKey, onPressed: () {
      final box = buttonKey.currentContext?.findRenderObject() as RenderBox?;
      if (box == null) return;
      Offset pos = box.localToGlobal(Offset(box.size.width, 0));
      showContextMenu(context, contextMenu: ContextMenu(
        shortcuts: {
          SingleActivator(LogicalKeyboardKey.keyC, control: true): () {
            print('Ctrl+C triggered');
          },
          SingleActivator(LogicalKeyboardKey.keyV, control: true): () {
            print('Ctrl+V triggered');
          },
        },
          position: pos,
          entries: [
              MenuItem(label: translations["newFile"].toString(), icon: Icons.add,),
              MenuItem(label: translations["save"].toString(), icon: Icons.save, onSelected: () async {
                Uint8List bytes = Uint8List.fromList(jsonEncode(ref.read(structsPod.notifier).structsToJson()).codeUnits);
                if (kIsWeb) {
                  download (bytes, downloadName: "structogram.json");
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
              }) ,
              MenuItem(label: translations["import"].toString(), icon: Icons.import_export, onSelected: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles();
                if (result == null) {
                  return;
                } else {
                  File file = File(result.files.first.path??"");
                  String data = file.readAsStringSync();
                  List<dynamic> json =  jsonDecode(data);
                  ref.read(structsPod.notifier).structsFromJson(json);
                }
              }),
              MenuItem(label: translations["importFromCode"].toString(), icon: Icons.code, onSelected: () {
                // final parser =
                // Parser(sharedLibrary: 'libdart.dylib', entryPoint: 'tree_sitter_dart');
                // final program = "class A {}";
                // final tree = parser.parse(program);
                // print(tree.root.string);
              }),

          ]
      ));
    }, icon: Icon(Icons.menu), );
  }
}
