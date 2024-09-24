import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/context_extension.dart';
import 'package:structogrammar/pages/struct_editor/hierarchy_tile.dart';
import 'package:structogrammar/riverpod/projects.dart';
import 'package:structogrammar/riverpod/structs.dart';
import 'package:structogrammar/riverpod/tabs.dart';

import '../../models/struct.dart';

class StructHierarchy extends ConsumerStatefulWidget {
  const StructHierarchy({super.key});

  @override
  ConsumerState createState() => _StructHierarchyState();
}

class _StructHierarchyState extends ConsumerState<StructHierarchy> {
  double minWidth = 250;
  bool expanded = true;

  @override
  Widget build(BuildContext context) {
    var tabs = ref.watch(tabsPod);
    var selected = ref.watch(selectedTabPod);
    int? projectId;
    try {
      projectId =
          tabs.firstWhere((element) => element.tabId == selected).projectId;
    } catch (_) {}
    if (projectId == null) return SizedBox();
    var projectStream = ref.watch(projectPod(projectId));
    return projectStream.when(
        data: (project) {
          List<HierarchyTileData> hierarchy = generateHierarchyTileTree(
              project.struct.value == null
                  ? []
                  : [project.struct.value!.toStruct()]);
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              width: minWidth,
              height: (expanded) ? context.height - 50 : 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SizedBox(
                height: context.height - 50,
                width: minWidth,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Hierarchy",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                              tooltip: (expanded) ? "Collapse" : "Expand",
                              onPressed: () {
                                setState(() {
                                  expanded = !expanded;
                                });
                              },
                              padding: EdgeInsets.zero,
                              icon: Icon(CupertinoIcons.sidebar_left)),
                        ],
                      ),
                    ),
                    if (expanded) Divider(),
                    if (expanded)
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              for (int i = 0; i < hierarchy.length; i++)
                                HierarchyTile(data: hierarchy[i]),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
        error: (e, s) => SizedBox(),
        loading: () => CircularProgressIndicator());
  }

  List<HierarchyTileData> generateHierarchyTileTree(List<Struct> structs) {
    // Helper function to generate tile data for a single struct
    HierarchyTileData getTileDataForStruct(Struct struct) {
      List<HierarchyTileData> children = [];
      for (var subStruct in struct.subStructs) {
        children.add(getTileDataForStruct(subStruct));
      }
      return HierarchyTileData(
        icon: Icon(
          getIcon(struct.type),
          size: 14,
        ),
        title: getTitle(struct),
        structType: struct.type,
        value: struct.id,
        onTap: (dynamic id) {
          int? intId;
          try {
            intId = id;
          } catch (_) {}
          if (intId == null) return;
          ref.read(selectedStructPod.notifier).state = intId;
        },
        children: children,
      );
    }

    return structs.map(getTileDataForStruct).toList();
  }

  String getTitle(Struct struct) {
    switch (struct.type) {
      case StructType.catchStatement:
        return "catch: ${struct.primaryValue}";
      case StructType.tryStatement:
        return "try";
      case StructType.caseStatement:
        return (struct.primaryValue == "default")
            ? "default:"
            : "case ${struct.primaryValue}:";
      default:
        return struct.primaryValue;
    }
  }

  IconData getIcon(StructType type) {
    switch (type) {
      case StructType.function:
        return CommunityMaterialIcons.code_braces;
      case StructType.instruction:
        return CommunityMaterialIcons.code_tags;
      case StructType.forLoop:
        return Icons.loop;
      case StructType.whileLoop:
        return Icons.loop;
      case StructType.doWhileLoop:
        return Icons.loop;
      case StructType.ifStatement:
        return CommunityMaterialIcons.code_parentheses;
      case StructType.switchStatement:
        return CommunityMaterialIcons.code_parentheses;
      default:
        return Icons.text_fields_sharp;
    }
  }
}
