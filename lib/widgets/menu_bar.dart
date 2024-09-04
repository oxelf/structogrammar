import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:menu_bar/menu_bar.dart';
import 'package:structogrammar/models/struct.dart';
import 'package:structogrammar/riverpod/state.dart';
import 'package:structogrammar/riverpod/structs.dart';
import 'package:structogrammar/util/uuid.dart';

class AppMenuBar extends ConsumerWidget {
  const AppMenuBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedStruct = ref.watch(selectedStructPod);
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
              "File",
              style: TextStyle(color: Colors.black),
            ),
            submenu: SubMenu(menuItems: [
              MenuButton(
                  text: Text("New File"),
                  icon: Icon(Icons.file_copy),
                  onTap: () async {
                  }),
              MenuButton(
                  text: Text("Save"),
                  icon: Icon(Icons.file_download),
                  onTap: () {})
            ])),
        BarButton(
            text: Text(
              "Diagramm",
              style: TextStyle(color: Colors.black),
            ),
            submenu: SubMenu(menuItems: [
              MenuButton(
                  text: Text("Add Function"),
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
      ],
      child: child,
    );
  }
}
