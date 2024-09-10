import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/riverpod/state.dart';
import 'package:structogrammar/widgets/actions_button.dart';
import 'package:structogrammar/widgets/hierarchy.dart';

class LeftPanel extends ConsumerStatefulWidget {
  const LeftPanel({super.key});

  @override
  ConsumerState createState() => _LeftPanelState();
}

class _LeftPanelState extends ConsumerState<LeftPanel> {
  @override
  Widget build(BuildContext context) {
    var width = ref.watch(leftFloatingPanelWidthPod);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight,
          width: width,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ActionsButton(),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text("Hierarchy", style: TextStyle(fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                child: HierarchyWidget(onMoved: (oldStruct, newStruct) {

                }),
              ),
            ),
            ],
          ),
        );
      }
    );
  }
}
