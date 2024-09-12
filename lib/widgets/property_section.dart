import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/context_extension.dart';
import 'package:structogrammar/models/struct.dart';
import 'package:structogrammar/widgets/property_builder.dart';

enum PropertyType { string, color, double, int, dropdown, list }

enum PropertySize { small, large }

class SectionProperty {
  PropertySize propertySize;
  PropertyType propertyType;
  dynamic propertyValue;
  String propertyKey;
  List<String>? possibleValues;
  List<String>? nonDeletableItems;
  Function(dynamic)? onChanged;

  SectionProperty(
      {required this.propertyType,
      required this.propertyKey,
      required this.propertyValue,
      this.possibleValues,
      this.propertySize = PropertySize.large, this.nonDeletableItems, this.onChanged});
}

class PropertySectionBuilder extends ConsumerStatefulWidget {
  const PropertySectionBuilder(
      {super.key,
      required this.data,
      required this.onChanged,
      required this.struct});

  final Map<String, dynamic> data;
  final Function(Map<String, dynamic>) onChanged;
  final Struct struct;

  @override
  ConsumerState createState() => _PropertySectionBuilderState();
}

class _PropertySectionBuilderState
    extends ConsumerState<PropertySectionBuilder> {
  bool lastWasSmall = false;
  List<String> texts = ["instruction", "condition", "text"];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<SectionProperty>> sections = getSections();
    return Column(
      children: [
        for (int i = 0; i < sections.length; i++)
          Builder(builder: (context) {
            return Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      sections.entries.elementAt(i).key,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                  ],
                ),
                for (int j = 0;
                    j < sections.entries.elementAt(i).value.length;
                    j++)
                  Builder(builder: (context) {
                    if (sections.entries.elementAt(i).value[j].propertySize ==
                        PropertySize.small) {
                      if (lastWasSmall) {
                        lastWasSmall = false;
                        return SizedBox();
                      }
                      lastWasSmall = true;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: PropertyBuilder(
                                property:
                                    sections.entries.elementAt(i).value[j],
                                onChanged: (key, value) {
                                  Map<String, dynamic> newData = widget.data;
                                  newData[key] = value;
                                  widget.onChanged.call(newData);
                                }),
                          ),
                          if (sections.entries.elementAt(i).value.length >
                              j + 1)
                            Expanded(
                              child: PropertyBuilder(
                                  property: sections.entries
                                      .elementAt(i)
                                      .value[j + 1],
                                  onChanged: (key, value) {
                                    Map<String, dynamic> newData = widget.data;
                                    newData[key] = value;
                                    widget.onChanged.call(newData);
                                  }),
                            ),
                        ],
                      );
                    } else {
                      return PropertyBuilder(
                          property: sections.entries.elementAt(i).value[j],
                          onChanged: (key, value) {
                            Map<String, dynamic> newData = widget.data;
                            newData[key] = value;
                            widget.onChanged.call(newData);
                          });
                    }
                  }),
                Divider(),
              ],
            );
          }),
      ],
    );
  }

  Map<String, List<SectionProperty>> getSections() {
    Map<String, List<SectionProperty>> sections = {};
    for (var entry in widget.data.entries) {
      if (texts.contains(entry.key)) {
        List<SectionProperty> properties = [
          SectionProperty(
              propertyType: PropertyType.string,
              propertyKey: entry.key,
              propertyValue: entry.value.toString()),
          SectionProperty(
              propertyType: PropertyType.dropdown,
              propertyKey: "textWeight",
              propertyValue: widget.data["textWeight"] ?? "regular",
              possibleValues: [
                "regular",
                "medium",
                "semibold",
                "bold",
                "extrabold"
              ],
              propertySize: PropertySize.small),
          SectionProperty(
              propertyType: PropertyType.int,
              propertyKey: "textSize",
              propertyValue: widget.data["textSize"] ?? 12,
              propertySize: PropertySize.small),
          SectionProperty(
              propertyType: PropertyType.color,
              propertyKey: "textColor",
              propertyValue: widget.data["textColor"] ?? "#FFFFFF",
              propertySize: PropertySize.large),
        ];
        String keyName = entry.key;
        if (keyName == "condition") {
          keyName = context.l.condition;
        }
        sections[keyName] = properties;
      }
      switch (entry.key) {
        case "comment":
          List<SectionProperty> properties = [
            SectionProperty(
                propertyType: PropertyType.string,
                propertyKey: "comment",
                propertyValue: entry.value),
            SectionProperty(
                propertyType: PropertyType.dropdown,
                propertyKey: "commentWeight",
                propertyValue: widget.data["commentWeight"] ?? "regular",
                possibleValues: [
                  "regular",
                  "medium",
                  "semibold",
                  "bold",
                  "extrabold"
                ],
                propertySize: PropertySize.small),
            SectionProperty(
                propertyType: PropertyType.int,
                propertyKey: "commentSize",
                propertyValue: widget.data["commentSize"] ?? 12,
                propertySize: PropertySize.small),
            SectionProperty(
                propertyType: PropertyType.color,
                propertyKey: "commentColor",
                propertyValue: widget.data["commentColor"] ?? "#FFFFFF",
                propertySize: PropertySize.large),
          ];
          sections["comment"] = properties;
        case "color":
          List<SectionProperty> properties = [
            SectionProperty(
                propertyType: PropertyType.color,
                propertyKey: "color",
                propertyValue: entry.value)
          ];
          // properties.add(SectionProperty(propertyType: PropertyType.color, propertyKey: propertyKey, propertyValue: propertyValue));
          sections[context.l.fillColor] = properties;
        default:
      }

    }

    if (widget.struct.type == StructType.caseSelect) {
      List<String> cases = [];
      for (int i = 0; i < widget.struct.subStructs.length; i++) {
        if (!cases.contains(widget.struct.subStructs[i].data["case"])) {
          cases.add(widget.struct.subStructs[i].data["case"]?? "");
        }
      }
      print("parsed cases: $cases");
      List<SectionProperty> properties = [
        SectionProperty(
            propertyType: PropertyType.list,
            propertyKey: "case",
            propertyValue: cases, onChanged: (value) {
              List<String> list = value;
              print("changed called: $list");
        }),
      ];
      // properties.add(SectionProperty(propertyType: PropertyType.color, propertyKey: propertyKey, propertyValue: propertyValue));
      sections[context.l.caseStatement] = properties;
    }

    return sections;
  }
}
