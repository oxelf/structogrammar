import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/context_extension.dart';
import 'package:structogrammar/riverpod/managers.dart';
import 'package:structogrammar/riverpod/state.dart';
import 'package:structogrammar/riverpod/structs.dart';
import 'package:structogrammar/widgets/inputs/text_field.dart';
import 'package:structogrammar/widgets/panel/panel.dart';


class EditPanel extends ConsumerStatefulWidget {
  const EditPanel({super.key});

  @override
  ConsumerState createState() => _EditPanelState();
}

class _EditPanelState extends ConsumerState<EditPanel> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var selectedStructStream = ref.watch(selectedStructStreamPod);
    return
      SidePanel(
        widthPod: structEditSidePanelPod,
        header: Text(
          context.l.edit,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: selectedStructStream.when(data: (selectedStruct) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PropertyTextfield(
                  value: selectedStruct.primaryValue,
                  autoFocus: true,
                  onChanged: (newValue) async {
                    var mgr = await ref.read(structManagerPod.future);
                    if (selectedStruct.id != null) mgr.changeStructPrimaryValue(selectedStruct.id!, newValue);
                  },
                ),
              ),
            ],
          );
        },
            error: (e, s) => Center(child: Text(e.toString()),),
            loading: () => Center(child: SizedBox(),)),
      );
  }
}
