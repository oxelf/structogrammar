import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/riverpod/structs.dart';
import 'package:structogrammar/widgets/hierachy_sub_widget.dart';

import '../models/struct.dart';

class HierarchyWidget extends ConsumerStatefulWidget {
  const HierarchyWidget({super.key, required this.onMoved});
  final Function(String structId, String newStructId) onMoved;
  @override
  ConsumerState createState() => _HierarchyWidgetState();
}

class _HierarchyWidgetState extends ConsumerState<HierarchyWidget> {
  @override
  Widget build(BuildContext context) {
    var structs = ref.watch(structsPod);
    Struct? struct = null;
    if (structs.length >= 1) {
      struct = structs[0];
    }
    return (struct != null )? LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            HierachySubWidget(struct: struct!, offset: 0, connectToTop: false,connnectToBottom: false,),
          ],
        );
      }
    ): Center(child: Text("no structs"),);
  }
}
