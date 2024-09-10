import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/context_extension.dart';
import 'package:structogrammar/models/struct.dart';
import 'package:structogrammar/riverpod/code_notifier.dart';
import 'package:structogrammar/riverpod/structs.dart';
import 'package:structogrammar/widgets/property_section.dart';


class EditPanel extends ConsumerStatefulWidget {
  const EditPanel({super.key});

  @override
  ConsumerState createState() => _EditPanelState();
}

class _EditPanelState extends ConsumerState<EditPanel> {
  List<String> ignoreProps = ["ifCondition", "dragging", "size", "startPosition", "loopType", "case"];

  @override
  Widget build(BuildContext context) {
    var currentStruct = ref.watch(currentStructPod);
    return (currentStruct == null)
        ? Center(
            child: Text("Select something to edit"),
          )
        : Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 8,),
                  Text(translateStructType(context, currentStruct.type), style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
              Divider(),
              PropertySectionBuilder(data: currentStruct.data, structType: currentStruct.type, onChanged: (data) {
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

String translateStructType(BuildContext context, StructType type) {
  switch (type) {
    case StructType.repeat:
      return context.l.repeat;
    case StructType.caseSelect:
      return context.l.caseSelect;
    case StructType.ifSelect:
      return context.l.ifSelect;
    case StructType.loop:
      return context.l.loop;
    case StructType.function:
      return context.l.function;
    case StructType.tryBlock:
      return "try";
    default:
      return context.l.instruction;
  }
}