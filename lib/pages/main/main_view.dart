import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/models/struct.dart';
import 'package:structogrammar/riverpod/state.dart';
import 'package:structogrammar/riverpod/structs.dart';
import 'package:structogrammar/widgets/struct_builder.dart';
import 'package:universal_html/html.dart';


class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  MainViewState createState() => MainViewState();
}

class MainViewState extends ConsumerState<MainView> {
  ScrollController horizontalScrollController = ScrollController();
  ScrollController verticalScrollController = ScrollController();
  @override
  void initState() {
    document.onContextMenu.listen((event) => event.preventDefault());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var structs = ref.watch(structsPod);
    var cursor = ref.watch(cursorPod);
    return MouseRegion(
      cursor: cursor,
      child: SingleChildScrollView(
        controller: verticalScrollController,
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              controller: horizontalScrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                // shrinkWrap: true,
                // buildDefaultDragHandles: false,
                // scrollDirection: Axis.horizontal,
                // onReorder: (int oldIndex, int newIndex) {
                //   ref.read(structsPod.notifier).reorderStructs(oldIndex, newIndex);
                // },
                children: [
                  for (int i = 0; i < structs.length; i++)
                    Column(key: Key(structs[i].id),
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                          StructBuilder(
                            dragIndex: i,
                            struct: structs[i],
                            bottomBorder: true,
                            maxWidth: 300 + (getMaxDepth(structs[i]) * 50),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

