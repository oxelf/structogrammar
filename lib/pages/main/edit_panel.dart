import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/riverpod/code_notifier.dart';
import 'package:structogrammar/riverpod/structs.dart';

import '../../widgets/color_picker.dart';

class EditPanel extends ConsumerStatefulWidget {
  const EditPanel({super.key});

  @override
  ConsumerState createState() => _EditPanelState();
}

class _EditPanelState extends ConsumerState<EditPanel> {
  List<String> ignoreProps = ["ifValue", "dragging", "size", "startPosition", "loopType"];

  @override
  Widget build(BuildContext context) {
    var currentStruct = ref.watch(currentStructPod);
    return (currentStruct == null)
        ? Center(
            child: Text("Select something to edit"),
          )
        : Column(
            children: [
              for (int i = 0; i < currentStruct.data.length; i++)
                if (!ignoreProps.contains(currentStruct.data.keys.elementAt(i)))
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      autofocus: (i == 0),
                      onChanged: (value) {
                        Map<String, dynamic> newData = currentStruct.data;
                        newData[currentStruct.data.keys.elementAt(i)] = value;
                        ref
                            .read(structsPod.notifier)
                            .editStructData(currentStruct.id, newData);
                        if (ref
                                .read(structsPod.notifier)
                                .findRootStruct(currentStruct.id) !=
                            null)
                          ref.read(codePod.notifier).generate(ref
                              .read(structsPod.notifier)
                              .findRootStruct(currentStruct.id)!);
                      },
                      controller: TextEditingController(
                          text: currentStruct.data.values
                              .elementAt(i)
                              .toString()),
                      decoration: InputDecoration(
                          label: Text(
                              currentStruct.data.keys.elementAt(i).toString()),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8))),
                    ),
                  ),
              Expanded(
                child: ColorPicker(
                  color: currentStruct.data["color"] ?? "#000000",
                  onChanged: (value) {
                    Map<String, dynamic> newData = currentStruct.data;
                    newData["color"] = value;
                    ref
                        .read(structsPod.notifier)
                        .editStructData(currentStruct.id, newData);
                    setState(() {});
                  },
                ),
              ),
            ],
          );
  }
}