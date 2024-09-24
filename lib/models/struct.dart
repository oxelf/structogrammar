import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:isar/isar.dart';
import 'package:structogrammar/riverpod/structs.dart';

part 'struct.g.dart';

enum StructFontWeight { w100, w200, w300, w400, w500, w600, w700, w800, w900 }

@embedded
class StructTextStyle {
  String? color;
  int? fontSize;
  @enumerated
  StructFontWeight fontWeight;
  String? fontFamily;

  StructTextStyle(
      {this.fontWeight = StructFontWeight.w400,
      this.color,
      this.fontSize,
      this.fontFamily});

  TextStyle toTextStyle() {
    return TextStyle(
      color: color != null ? HexColor(color!) : null,
      fontSize: fontSize?.toDouble() ?? 14,
      fontWeight: getFontWeight(),
      fontFamily: fontFamily,
    );
  }

  FontWeight getFontWeight() {
    switch (fontWeight) {
      case StructFontWeight.w100:
        return FontWeight.w100;
      case StructFontWeight.w200:
        return FontWeight.w200;
      case StructFontWeight.w300:
        return FontWeight.w300;
      case StructFontWeight.w400:
        return FontWeight.w400;
      case StructFontWeight.w500:
        return FontWeight.w500;
      case StructFontWeight.w600:
        return FontWeight.w600;
      case StructFontWeight.w700:
        return FontWeight.w700;
      case StructFontWeight.w800:
        return FontWeight.w800;
      case StructFontWeight.w900:
        return FontWeight.w900;
      default:
        return FontWeight.normal;
    }
  }

  factory StructTextStyle.functionStyle() {
    return StructTextStyle(
      fontSize: 20,
      fontWeight: StructFontWeight.w700,
    );
  }
}

enum StructType {
  function,
  instruction,
  ifStatement,
  ifCondition,
  switchStatement,
  caseStatement,
  forLoop,
  whileLoop,
  doWhileLoop,
  callStatement,
  returnStatement,
  tryStatement,
  catchStatement,
}

@embedded
class Struct {
  int? id;
  @enumerated
  StructType type;
  String primaryValue;
  String secondaryValue;
  double? width;
  StructTextStyle? structTextStyle;
  List<Struct> subStructs;

  Struct({
    this.id,
    this.type = StructType.instruction,
    this.primaryValue = "",
    this.secondaryValue = "",
    this.width,
    this.structTextStyle,
    this.subStructs = const [],
  }) {
    id ??= StructsId.getId();
  }

  Struct copy() {
    return Struct(
      id: StructsId.getId(),
      type: type,
      primaryValue: primaryValue,
      secondaryValue: secondaryValue,
      width: width,
      structTextStyle: structTextStyle,
      subStructs: subStructs.map((e) => e.copy()).toList(),
    );
  }
}

@Collection(accessor: "structs")
class StructHead {
  Id id = Isar.autoIncrement;
  @enumerated
  StructType type;
  String primaryValue;
  String secondaryValue;
  double? width;
  StructTextStyle? structTextStyle;
  List<Struct> subStructs;

  StructHead({
    this.type = StructType.instruction,
    this.primaryValue = "",
    this.secondaryValue = "",
    this.width,
    this.structTextStyle,
    this.subStructs = const [],
  });

  Struct toStruct() {
    return Struct(
      id: id,
      type: type,
      primaryValue: primaryValue,
      secondaryValue: secondaryValue,
      width: width,
      structTextStyle: structTextStyle,
      subStructs: subStructs,
    );
  }
}
