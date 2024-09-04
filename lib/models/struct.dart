import 'package:equatable/equatable.dart';
import 'package:structogrammar/util/uuid.dart';

enum StructType {
  function,
  instruction,
  ifSelect,
  caseSelect,
  loop,
  repeat,
  tryBlock,
}

extension StructTypeExtension on StructType {
  StructType? getFromString(String stringType) {
    for  (var structType in StructType.values) {
      if (structType.toString() == stringType) {
        return structType;
      }
    }
    return null;
  }
}

class Struct extends Equatable {
  String id;
  StructType type;
  Map<String, dynamic> data;
  List<Struct> subStructs;

  Struct(
      {required this.id,
      required this.type,
      required this.data,
      required this.subStructs});

  @override
  List<Object> get props => [id, type, data, subStructs];

  Struct copyWith({Map<String, dynamic>? data, List<Struct>? subStructs}) {
    return Struct(
        id: this.id,
        type: this.type,
        data: data ?? this.data,
        subStructs: subStructs ?? this.subStructs);
  }

  factory Struct.function(
      String name, String returnType, List<Struct> subStructs,
      {Map<String, dynamic>? additionalData}) {
    Map<String, dynamic> newData = additionalData ?? {};
    newData["name"] = name;
    newData["returnType"] = returnType;
    newData["comment"] = "";
    return Struct(
        id: generateUUID(),
        type: StructType.function,
        data: newData,
        subStructs: subStructs);
  }

  factory Struct.instruction(String instruction,
      {Map<String, dynamic>? additionalData}) {
    Map<String, dynamic> newData = additionalData ?? {};
    newData["instruction"] = instruction;
    newData["comment"] = "";
    return Struct(
        id: generateUUID(),
        type: StructType.instruction,
        data: newData,
        subStructs: []);
  }

  factory Struct.loop(String condition,String loopType, List<Struct> subStructs,
      {Map<String, dynamic>? additionalData}) {
    Map<String, dynamic> newData = additionalData ?? {};
    newData["condition"] = condition;
    newData["comment"] = "";
    newData["loopType"] = loopType;
    return Struct(
        id: generateUUID(),
        type: StructType.loop,
        data: newData,
        subStructs: subStructs);
  }

  factory Struct.until(String condition, List<Struct> subStructs,
      {Map<String, dynamic>? additionalData}) {
    Map<String, dynamic> newData = additionalData ?? {};
    newData["condition"] = condition;
    newData["comment"] = "";
    return Struct(
        id: generateUUID(),
        type: StructType.repeat,
        data: newData,
        subStructs: subStructs);
  }



  factory Struct.ifStatement(String condition,
      {required List<Struct> trueSubStructs,
      required List<Struct> falseSubStructs,
      Map<String, dynamic>? additionalData}) {
    Map<String, dynamic> newData = additionalData ?? {};
    newData["condition"] = condition;
    newData["comment"] = "";
    for (int i = 0; i < trueSubStructs.length; i++) {
      trueSubStructs[i].data["ifValue"] = true;
    }
    for (int i = 0; i < falseSubStructs.length; i++) {
      falseSubStructs[i].data["ifValue"] = false;
    }
    //Struct trueStruct = Struct.instruction("do on true", additionalData:  {"ifValue": true});
    //Struct falseStruct = Struct.instruction("do on false", additionalData:  {"ifValue": false});
    return Struct(
        id: generateUUID(),
        type: StructType.ifSelect,
        data: newData,
        subStructs: [
          ...trueSubStructs,
          ...falseSubStructs,
        ]);
  }
}

int getMaxDepth(Struct struct) {
  // Base case: if there are no subStructs, depth is 1
  if (struct.subStructs.isEmpty) {
    return 1;
  }

  // Recursive case: compute the depth for each subStruct and take the maximum
  int maxDepth = 0;
  for (Struct subStruct in struct.subStructs) {
    int subDepth = getMaxDepth(subStruct);
    if (subDepth > maxDepth) {
      maxDepth = subDepth;
    }
  }

  // Add 1 to account for the current level
  return maxDepth + 1;
}
