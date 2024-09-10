import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/models/struct.dart';
import 'package:structogrammar/riverpod/code_notifier.dart';
import 'package:structogrammar/riverpod/state.dart';
import 'package:structogrammar/util/uuid.dart';

import '../models/struct.dart';


class StructsNotifier extends Notifier<List<Struct>> {
  @override
  List<Struct> build() {
    return [
      Struct(id: "main", type: StructType.function, data: {"text": "main", "comment": "", "size": "400", "textSize": 20, "textWeight": "bold"}, subStructs: [ Struct(id: "entry_instruction", type: StructType.instruction, data: {"instruction": "", "comment": ""}, subStructs: []),]),
    ];
  }

  List<dynamic> structsToJson() {
    List<dynamic> json = [];
    for (int i = 0; i < state.length; i++) {
      json.add(state[i].toJson());
    }
    return json;
  }

  void structsFromJson(List<dynamic> json) {
    List<Struct> structs = [];
    for (int i = 0; i < json.length; i++) {
      structs.add(Struct.fromJson(json[i]));
    }
    state = structs;
  }

  void addStruct(Struct struct) {
    state = [...state, struct];
    ref.read(selectedStructPod.notifier).state = struct.id;
  }

  void reorderStructs(int oldIndex, int newIndex) {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      Struct? item = removeAt(oldIndex);
      if (item != null) {
        insertAt(newIndex, item);
      }
  }

  Struct? findParentStruct(String structId) {
    Struct? searchParent(List<Struct> structs) {
      for (var struct in structs) {
        if (struct.subStructs.any((s) => s.id == structId)) {
          return struct;
        }
        var result = searchParent(struct.subStructs);
        if (result != null) {
          return result;
        }
      }
      return null;
    }

    for (var struct in state) {
      var result = searchParent([struct]);
      if (result != null) {
        return result;
      }
    }

    return null;  // Return null if no parent is found
  }


  void moveStruct(Struct struct, String targetStructId, int index) {
      // Step 1: Find the parent struct of the struct to be moved.
      Struct? parentStruct = findParentStruct(struct.id);

      // Step 2: If the parent is the same as the target, adjust the index accordingly.
      bool isSameParent = parentStruct != null && parentStruct.id == targetStructId;

      if (isSameParent) {
        // Adjust the index if moving within the same parent
        int currentIndex = parentStruct!.subStructs.indexWhere((s) => s.id == struct.id);
        if (currentIndex < index) {
          index -= 1;
        }
      }

      // Step 3: Remove the struct from its current location.
      removeStruct(struct.id);

      // Step 4: Find the target struct where we want to move our struct.
      Struct? targetStruct = findStructById(targetStructId);
      if (targetStruct != null) {
        // Step 5: Create a new list of subStructs with the struct inserted at the specified index.
        List<Struct> newSubStructs = List.from(targetStruct.subStructs);
        newSubStructs.insert(index, struct);

        // Step 6: Create a new list for the updated state, updating the target struct.
        List<Struct> updatedState = [];
        for (var i = 0; i < state.length; i++) {
          if (state[i].id == targetStruct.id) {
            updatedState.add(state[i].copyWith(subStructs: newSubStructs));
          } else {
            updatedState.add(state[i]);
          }
        }

        // Step 7: Update the state.
        state = updatedState;
      } else {
        // Log an error if the target struct is not found (optional but useful for debugging).
        print("Error: Target struct with ID $targetStructId not found.");
      }
    }






    Struct? removeAt(int index) {
    Struct? struct = state.elementAtOrNull(index);
    state = [for (var i = 0; i < state.length; i++) if (i != index) state[i]];
    return struct;
  }

  void insertAt(int index, Struct item) {
    state = [
      for (var i = 0; i < index; i++) state[i],
      item,
      for (var i = index; i < state.length; i++) state[i],
    ];
  }


  void removeStruct(String structId) {
    List<Struct> newState = [];

    // Recursive function to remove the struct with the given ID
    bool removeStructRecursive(List<Struct> structs) {
      for (var i = 0; i < structs.length; i++) {
        if (structs[i].id == structId) {
          structs.removeAt(i);
          return true;  // Stop after removing
        }
        // Recursively search through the subStructs
        if (removeStructRecursive(structs[i].subStructs)) {
          // Stop if the struct was removed in a subStruct
          return true;
        }
      }
      return false;
    }

    // Copy the state and process each struct
    for (var i = 0; i < state.length; i++) {
      var copiedStruct = state[i].copyWith();
      removeStructRecursive([copiedStruct]);
      newState.add(copiedStruct);
    }

    for (var i = 0; i < newState.length; i++) {
     if (newState[i].id == structId) {
       newState.removeAt(i);
     }
    }

    state = newState;
  }


  void insertSubStruct(String structId, Struct struct, int index) {
    List<Struct> newState = [];

    void addSubStructRecursive(List<Struct> structs) {
      for (var i = 0; i < structs.length; i++) {
        if (structs[i].id == structId) {
          if (structs[i].subStructs.length <= index) {
            structs[i].subStructs.add(struct);
          } else {
            structs[i].subStructs.insert(index, struct);
          }
        }
        addSubStructRecursive(structs[i].subStructs);
      }
    }

    for (var i = 0; i < state.length; i++) {
      var copiedStruct = state[i].copyWith();
      addSubStructRecursive([copiedStruct]);
      newState.add(copiedStruct);
    }

    state = newState;
  }

  void addSubStruct(String structId, Struct struct) {
    List<Struct> newState = [];

    void addSubStructRecursive(List<Struct> structs) {
      for (var i = 0; i < structs.length; i++) {
        if (structs[i].id == structId) {
          structs[i].subStructs.add(struct);
        }
        addSubStructRecursive(structs[i].subStructs);
      }
    }

    for (var i = 0; i < state.length; i++) {
      var copiedStruct = state[i].copyWith();
      addSubStructRecursive([copiedStruct]);
      newState.add(copiedStruct);
    }

    state = newState;
  }

  void editStructData(String structId, Map<String, dynamic> newData) {
    List<Struct> newState = [];

    // Recursive function to find and edit the struct data
    void editStructDataRecursive(List<Struct> structs) {
      for (var i = 0; i < structs.length; i++) {
        if (structs[i].id == structId) {
          // Replace the data of the struct with the new data
          structs[i] = structs[i].copyWith(data: newData);
          return;  // Stop after modification
        }
        // Recursively search and edit the subStructs
        editStructDataRecursive(structs[i].subStructs);
      }
    }

    // Copy the state and process each struct
    for (var i = 0; i < state.length; i++) {
      var copiedStruct = state[i].copyWith();
      editStructDataRecursive([copiedStruct]);
      newState.add(copiedStruct);
    }

    // Update the state with the new struct data
    state = newState;
  }


  Struct? findStructById(String structId) {
    Struct? searchInSubStructs(List<Struct> structs) {
      for (var struct in structs) {
        if (struct.id == structId) {
          return struct;  // Found the target struct, return it
        }
        var result = searchInSubStructs(struct.subStructs);
        if (result != null) {
          return result;  // If found in subStructs, return the result
        }
      }
      return null;
    }

    for (var struct in state) {
      var result = searchInSubStructs([struct]);
      if (result != null) {
        return result;
      }
    }

    return null;  // Return null if no matching structId is found
  }


  Struct? findRootStruct(String structId) {
    Struct? searchInSubStructs(List<Struct> structs) {
      for (var struct in structs) {
        if (struct.id == structId) {
          return struct;
        }
        var result = searchInSubStructs(struct.subStructs);
        if (result != null) {
          return struct;  // Return the current struct as it is the parent of the found struct
        }
      }
      return null;
    }

    for (var struct in state) {
      var result = searchInSubStructs([struct]);
      if (result != null) {
        return struct;
      }
    }

    return null;  // Return null if no matching structId is found
  }



  void addStructBefore(String structId, Struct newStruct) {
    List<Struct> newState = [];

    // Recursive function to insert the struct before the target
    bool insertBefore(List<Struct> structs) {
      for (var i = 0; i < structs.length; i++) {
        if (structs[i].id == structId) {
          structs.insert(i, newStruct);
          return true;  // Stop after insertion
        }
        // Recursively search through the subStructs
        if (insertBefore(structs[i].subStructs)) {
          return true;  // Stop if found and inserted in a subStruct
        }
      }
      return false;
    }

    // Copy the state and process each struct
    for (var i = 0; i < state.length; i++) {
      var copiedStruct = state[i].copyWith();
      insertBefore([copiedStruct]);
      newState.add(copiedStruct);
    }

    state = newState;
  }

  void addStructAfter(String structId, Struct newStruct) {
    List<Struct> newState = [];

    // Recursive function to insert the struct after the target
    bool insertAfter(List<Struct> structs) {
      for (var i = 0; i < structs.length; i++) {
        if (structs[i].id == structId) {
          structs.insert(i + 1, newStruct);
          return true;  // Stop after insertion
        }
        // Recursively search through the subStructs
        if (insertAfter(structs[i].subStructs)) {
          return true;  // Stop if found and inserted in a subStruct
        }
      }
      return false;
    }

    // Copy the state and process each struct
    for (var i = 0; i < state.length; i++) {
      var copiedStruct = state[i].copyWith();
      insertAfter([copiedStruct]);
      newState.add(copiedStruct);
    }

    state = newState;
  }

}




final structsPod = NotifierProvider<StructsNotifier, List<Struct>>((){
  return StructsNotifier();
});

final currentStructPod = Provider<Struct?>((ref) {
  var selectedStructId = ref.watch(selectedStructPod);
  var structs = ref.watch(structsPod);
  return ref.read(structsPod.notifier).findStructById(selectedStructId);
});