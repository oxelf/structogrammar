// import 'package:isar/isar.dart';
// import 'package:structogrammar/models/project.dart';
// import 'package:structogrammar/models/struct.dart';
//
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:structogrammar/main.dart';
import 'package:structogrammar/models/project.dart';
import 'package:structogrammar/models/struct.dart';
import 'package:structogrammar/pages/struct_editor/hierarchy_tile.dart';
import 'package:structogrammar/riverpod/structs.dart';
import 'package:toastification/toastification.dart';

List<StructType> subStructStructTypes = [
  StructType.function,
  StructType.ifCondition,
  StructType.caseStatement,
  StructType.whileLoop,
  StructType.forLoop,
  StructType.doWhileLoop,
  StructType.tryStatement,
  StructType.catchStatement,
];

class StructsManager {
  const StructsManager(this.isar);

  final Isar isar;

  Future<int> getHighestId() async {
    int highest = 100000;

    // Fetch all projects
    List<Project> projects = await isar.projects.where().findAll();

    // Helper function to recursively find the highest id
    void findHighestId(Struct struct) {
      if ((struct.id ?? 0) > highest) {
        highest = struct.id ?? 0;
      }

      // Recursively check substructs
      for (var subStruct in struct.subStructs) {
        findHighestId(subStruct);
      }
    }

    // Iterate through each project
    for (int i = 0; i < projects.length; i++) {
      if (projects[i].struct.value == null) continue;

      Struct struct = projects[i].struct.value!.toStruct();
      findHighestId(struct); // Start the recursive search
    }

    return highest; // Return the highest id found
  }

  Future<void> resizeStruct(int id, double newWidth) async {
    final projects = await isar.projects.where().findAll();

    for (final project in projects) {
      final structHead = project.struct.value;

      if (structHead != null && structHead.id == id) {
        structHead.width = newWidth;
        project.struct.value = structHead;
        isar.writeTxnSync(() {
          isar.structs.putSync(structHead);
          isar.projects.putSync(project);
        });
        return;
      }
    }
  }

  Future<Struct?> getStruct(int structId) async {
    final projects = await isar.projects.where().findAll();

    for (final project in projects) {
      final structHead = project.struct.value; // Get the StructHead

      if (structHead != null) {
        Struct? findStructById(Struct struct, int structId) {
          if (struct.id == structId) {
            return struct;
          }

          for (final subStruct in struct.subStructs) {
            final result = findStructById(subStruct, structId);
            if (result != null) {
              return result;
            }
          }

          return null;
        }

        final struct = findStructById(structHead.toStruct(), structId);
        if (struct != null) {
          return struct;
        }
      }
    }

    return null;
  }

  Future<Struct?> getParentStruct(int structId) async {
    Struct? findParentStruct(Struct parent, int structId) {
      for (final subStruct in parent.subStructs) {
        if (subStruct.id == structId) {
          return parent;
        }
        final result = findParentStruct(subStruct, structId);
        if (result != null) {
          return result;
        }
      }
      return null;
    }

    final projects = await isar.projects.where().findAll();

    for (final project in projects) {
      final structHead = project.struct.value;
      if (structHead != null) {
        final parent = findParentStruct(structHead.toStruct(), structId);
        if (parent != null) {
          return parent;
        }
      }
    }

    return null;
  }

  Future<void> moveStruct(
      int structId, int targetStructId, StructDragLocation location) async {
    print("moving struct $structId to $targetStructId at $location");
    if (structId == targetStructId) {
      return;
    }
    Struct? struct = await getStruct(structId);
    Struct? targetStruct = await getParentStruct(targetStructId);
    if (struct == null || targetStruct == null) {
      toastification.show(
        context: navigatorKey.currentContext,
        type: ToastificationType.warning,
        style: ToastificationStyle.flat,
        title: const Text("Block not found"),
        description:
            const Text("We couldn't find the block you are trying to move"),
        alignment: Alignment.bottomRight,
        autoCloseDuration: const Duration(seconds: 4),
        boxShadow: lowModeShadow,
      );
      return;
    }
    if (nonDraggableStructTypes.contains(struct.type)) {
      toastification.show(
        context: navigatorKey.currentContext,
        type: ToastificationType.warning,
        style: ToastificationStyle.flat,
        title: const Text("Block couldn't be moved"),
        description: const Text("This kind of block can't be moved"),
        alignment: Alignment.bottomRight,
        autoCloseDuration: const Duration(seconds: 4),
        boxShadow: lowModeShadow,
      );
      return;
    }

    if (!subStructStructTypes.contains(targetStruct.type)) {
      toastification.show(
        context: navigatorKey.currentContext,
        type: ToastificationType.warning,
        style: ToastificationStyle.flat,
        title: const Text("Block couldn't be moved"),
        description: const Text("Blocks can't be moved inside this block"),
        alignment: Alignment.bottomRight,
        autoCloseDuration: const Duration(seconds: 4),
        boxShadow: lowModeShadow,
      );
      return;
    }

    // Check if the parent's substructs will be empty before removing the struct
    Struct? parentStruct = await getParentStruct(structId);
    if (parentStruct != null && parentStruct.subStructs.length == 1) {
      toastification.show(
        context: navigatorKey.currentContext,
        type: ToastificationType.warning,
        style: ToastificationStyle.flat,
        title: const Text("Block couldn't be moved"),
        description: const Text("The parent's substructs can't be empty"),
        alignment: Alignment.bottomRight,
        autoCloseDuration: const Duration(seconds: 4),
        boxShadow: lowModeShadow,
      );
      return;
    }

    // Remove the struct from its current location
    await deleteStruct(structId);

    // Add the struct to the new location
    switch (location) {
      case StructDragLocation.before:
        await addStructBefore(targetStructId, struct);
        break;
      case StructDragLocation.after:
        await addStructAfter(targetStructId, struct);
        break;
        // case StructDragLocation.inside:
        //   await addStructInside(targetStruct, struct);
    }
  }

  Future<void> addStructInside(int structId, Struct newStruct) async {
    Struct? addStructById(Struct struct, int structId, Struct newStruct) {
      struct.subStructs = struct.subStructs.toList();

      for (int i = 0; i < struct.subStructs.length; i++) {
        if (struct.subStructs[i].id == structId) {
          struct.subStructs[i].subStructs =
              struct.subStructs[i].subStructs.toList();
          struct.subStructs[i].subStructs.add(newStruct);
          return struct;
        }

        Struct? result =
            addStructById(struct.subStructs[i], structId, newStruct);
        if (result != null) {
          struct.subStructs[i] = result;
          return struct;
        }
      }

      return null;
    }

    final projects = await isar.projects.where().findAll();

    for (final project in projects) {
      final structHead = project.struct.value; // Get the StructHead

      if (structHead != null) {
        var subStructs = structHead.subStructs.toList();
        for (int i = 0; i < subStructs.length; i++) {
          if (subStructs[i].id == structId) {
            subStructs[i].subStructs = subStructs[i].subStructs.toList();
            subStructs[i].subStructs.add(newStruct);
            structHead.subStructs = subStructs;
            project.struct.value = structHead;
            isar.writeTxnSync(() {
              isar.structs.putSync(structHead);
              isar.projects.putSync(project);
            });
            return;
          } else {
            Struct? added = addStructById(subStructs[i], structId, newStruct);
            if (added != null) {
              subStructs[i] = added;
              structHead.subStructs = subStructs;
              project.struct.value = structHead;
              isar.writeTxnSync(() {
                isar.structs.putSync(structHead);
                isar.projects.putSync(project);
                return;
              });
            }
          }
        }
      }
    }
  }

  Future<void> addStructBefore(int structId, Struct newStruct) async {
    Struct? addStructById(Struct struct, int structId, Struct newStruct) {
      struct.subStructs = struct.subStructs.toList();

      for (int i = 0; i < struct.subStructs.length; i++) {
        if (struct.subStructs[i].id == structId) {
          struct.subStructs.insert(i, newStruct);
          return struct;
        }

        Struct? result =
            addStructById(struct.subStructs[i], structId, newStruct);
        if (result != null) {
          struct.subStructs[i] = result;
          return struct;
        }
      }

      return null;
    }

    final projects = await isar.projects.where().findAll();

    for (final project in projects) {
      final structHead = project.struct.value; // Get the StructHead

      if (structHead != null) {
        var subStructs = structHead.subStructs.toList();
        for (int i = 0; i < subStructs.length; i++) {
          if (subStructs[i].id == structId) {
            subStructs.insert(i, newStruct);
            structHead.subStructs = subStructs;
            project.struct.value = structHead;
            isar.writeTxnSync(() {
              isar.structs.putSync(structHead);
              isar.projects.putSync(project);
            });
            return;
          } else {
            Struct? added = addStructById(subStructs[i], structId, newStruct);
            if (added != null) {
              subStructs[i] = added;
              structHead.subStructs = subStructs;
              project.struct.value = structHead;
              isar.writeTxnSync(() {
                isar.structs.putSync(structHead);
                isar.projects.putSync(project);
                return;
              });
            }
          }
        }
      }
    }
  }

  Future<void> addStructAfter(int structId, Struct newStruct) async {
    Struct? addStructById(Struct struct, int structId, Struct newStruct) {
      struct.subStructs = struct.subStructs.toList();

      for (int i = 0; i < struct.subStructs.length; i++) {
        if (struct.subStructs[i].id == structId) {
          struct.subStructs.insert(i + 1, newStruct);
          return struct;
        }

        Struct? result =
            addStructById(struct.subStructs[i], structId, newStruct);
        if (result != null) {
          struct.subStructs[i] = result;
          return struct;
        }
      }

      return null;
    }

    final projects = await isar.projects.where().findAll();

    for (final project in projects) {
      final structHead = project.struct.value; // Get the StructHead

      if (structHead != null) {
        var subStructs = structHead.subStructs.toList();
        for (int i = 0; i < subStructs.length; i++) {
          if (subStructs[i].id == structId) {
            subStructs.insert(i + 1, newStruct);
            structHead.subStructs = subStructs;
            project.struct.value = structHead;
            isar.writeTxnSync(() {
              isar.structs.putSync(structHead);
              isar.projects.putSync(project);
            });
            return;
          } else {
            Struct? added = addStructById(subStructs[i], structId, newStruct);
            if (added != null) {
              subStructs[i] = added;
              structHead.subStructs = subStructs;
              project.struct.value = structHead;
              isar.writeTxnSync(() {
                isar.structs.putSync(structHead);
                isar.projects.putSync(project);
                return;
              });
            }
          }
        }
      }
    }
  }

  Future<void> deleteStruct(int structId) async {
    Struct? parent = await getParentStruct(structId);
    if (parent == null) {
      toastification.show(
        context: navigatorKey.currentContext,
        type: ToastificationType.warning,
        style: ToastificationStyle.flat,
        title: const Text("Couldn't delete block"),
        description: const Text("The blocks was not found"),
        alignment: Alignment.bottomRight,
        autoCloseDuration: const Duration(seconds: 4),
        boxShadow: lowModeShadow,
      );
      return;
    }

    if (parent.subStructs.length < 2) {
      toastification.show(
        context: navigatorKey.currentContext,
        type: ToastificationType.warning,
        style: ToastificationStyle.flat,
        title: const Text("Couldn't delete block"),
        description: const Text("The blocks parent cant be empty"),
        alignment: Alignment.bottomRight,
        autoCloseDuration: const Duration(seconds: 4),
        boxShadow: lowModeShadow,
      );
      return;
    }

    Struct? removeStructById(Struct struct, int structId) {
      struct.subStructs = struct.subStructs.toList();

      for (int i = 0; i < struct.subStructs.length; i++) {
        if (struct.subStructs[i].id == structId) {
          struct.subStructs.removeAt(i);
          return struct;
        }

        Struct? result = removeStructById(struct.subStructs[i], structId);
        if (result != null) {
          struct.subStructs[i] = result;
          return struct;
        }
      }

      return null;
    }


    final projects = await isar.projects.where().findAll();

    for (final project in projects) {
      final structHead = project.struct.value; // Get the StructHead

      if (structHead != null) {
        var subStructs = structHead.subStructs.toList();
        bool found = false;
        for (int i = 0; i < subStructs.length; i++) {
          if (subStructs[i].id == structId) {
            subStructs.removeAt(i);
            structHead.subStructs = subStructs;
            project.struct.value = structHead;
            isar.writeTxnSync(() {
              isar.structs.putSync(structHead);
              isar.projects.putSync(project);
            });
            found = true;
            return;
          } else {
            Struct? removed = removeStructById(subStructs[i], structId);
            if (removed != null) {
              subStructs[i] = removed;
              structHead.subStructs = subStructs;
              project.struct.value = structHead;
              isar.writeTxnSync(() {
                isar.structs.putSync(structHead);
                isar.projects.putSync(project);
              });
              found = true;
              return;
            }
          }
        }
      }
    }
  }

// Stream<Struct> watchStruct(int structId) async* {
//   final query = isar.structs.where().idEqualTo(structId).build();
//
//   await for (final results in query.watch(fireImmediately: true)) {
//     if (results.length > 0) {
//       yield results[0];
//     }
//   }
// }
//
// Future<int?> addStruct(Struct struct) async {
//   int? sId;
//    isar.writeTxnSync(()  {
//     sId =  isar.structs.putSync(struct);
//   });
//   return sId;
// }
//
// void updateStruct(Struct struct) async {
//   isar.writeTxnSync(() {
//     isar.structs.putSync(struct);
//   });
// }
//
// void deleteStruct(int structId) async {
//   Struct? struct = getStruct(structId);
//   if (struct == null) return;
//   isar.writeTxnSync(() {
//     isar.structs.deleteSync(structId);
//   });
// }
//
// Struct? getStruct(int structId) {
//   return isar.structs.filter().idEqualTo(structId).build().findFirstSync();
// }
//
// Future<bool> exists(int projectId) async {
//   return await isar.projects.filter().idEqualTo(projectId).isNotEmpty();
// }
}
