import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:menu_bar/menu_bar.dart';
import 'package:structogrammar/models/struct.dart';
import 'package:structogrammar/riverpod/settings.dart';
import 'package:structogrammar/riverpod/state.dart';
import 'package:structogrammar/riverpod/structs.dart';
import 'package:structogrammar/riverpod/translation.dart';
import 'package:structogrammar/util/uuid.dart';

import 'context_menu.dart';

class AppMenuBar extends ConsumerWidget {
  const AppMenuBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedStruct = ref.watch(selectedStructPod);
    var translations = ref.watch(translationsPod);
    var settings = ref.watch(settingsPod);
    return MenuBarWidget(
      enabled: true,
      barStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(
            Colors.grey.shade200,
          ),
          shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.zero))),
      barButtons: [
        BarButton(
            text: Text(
              translations["file"].toString(),
              style: TextStyle(color: Colors.black),
            ),
            submenu: SubMenu(menuItems: [
              MenuButton(
                  text: Text(translations["newFile"].toString()),
                  icon: Icon(Icons.file_copy),
                  onTap: () async {

                  }),
              MenuButton(
                  text: Text(translations["import"].toString()),
                  icon: Icon(Icons.open_in_new),
                  shortcutText: "",
                  onTap: () async {
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
              MenuButton(
                  text: Text(translations["save"].toString()),
                  icon: Icon(Icons.file_download),
                  onTap: () async {
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
                  })
            ])),
        BarButton(
            text: Text(
             translations["diagram"].toString(),
              style: TextStyle(color: Colors.black),
            ),
            submenu: SubMenu(menuItems: [
              MenuButton(
                  text: Text(translations["addFunction"].toString()),
                  icon: Icon(Icons.add),
                  onTap: () {
                    ref.read(structsPod.notifier).addStruct(Struct(
                            id: generateUUID(),
                            type: StructType.function,
                            data: {
                              "name": "main",
                              "comment": "",
                              "size": "400",
                            },
                            subStructs: [
                              Struct.instruction(""),
                            ]));
                  })
            ])),
        BarButton(
            text: Text(
              translations["language"].toString(),
              style: TextStyle(color: Colors.black),
            ),
            submenu: SubMenu(menuItems: [
              MenuButton(
                  text: Text(translations["english"].toString()),
                  icon: Text("🇺🇸"),
                  shortcutText: (settings.language == "en")?" selected": "",
                  onTap: () {
                    ref.read(settingsPod.notifier).setLanguage("en");
                  }),MenuButton(
                  text: Text(translations["german"].toString()),
                  shortcutText: (settings.language == "de")?" selected": "",
                  icon: Text("🇩🇪"),
                  onTap: () {
                  ref.read(settingsPod.notifier).setLanguage("de");
                  }),
            ])),
      ],
      child: child,
    );
  }
}
