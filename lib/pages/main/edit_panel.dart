import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/riverpod/code_notifier.dart';
import 'package:structogrammar/riverpod/structs.dart';
import 'package:structogrammar/riverpod/translation.dart';
import 'package:structogrammar/widgets/property_section.dart';
import 'package:structogrammar/widgets/property_textfield.dart';

import '../../widgets/color_picker.dart';

class EditPanel extends ConsumerStatefulWidget {
  const EditPanel({super.key});

  @override
  ConsumerState createState() => _EditPanelState();
}

class _EditPanelState extends ConsumerState<EditPanel> {
  List<String> ignoreProps = ["ifValue", "dragging", "size", "startPosition", "loopType", "case"];

  @override
  Widget build(BuildContext context) {
    var currentStruct = ref.watch(currentStructPod);
    var translations = ref.watch(translationsPod);
    return (currentStruct == null)
        ? Center(
            child: Text("Select something to edit"),
          )
        : Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 8,),
                  Text(translations[currentStruct.type.toString()] ?? currentStruct.type.toString(), style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
              Divider(),
              PropertySectionBuilder(data: currentStruct.data, onChanged: (data) {
                ref.read(structsPod.notifier).editStructData(currentStruct.id, data);
                if (ref
                    .read(structsPod.notifier)
                    .findRootStruct(currentStruct.id) !=
                    null)
                  ref.read(codePod.notifier).generate(ref
                      .read(structsPod.notifier)
                      .findRootStruct(currentStruct.id)!);
              }),
            ],
          );
  }
}
