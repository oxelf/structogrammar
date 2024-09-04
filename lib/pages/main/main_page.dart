import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resizable_widget/resizable_widget.dart';
import 'package:structogrammar/pages/main/right_panel.dart';
import 'package:structogrammar/riverpod/code_notifier.dart';
import 'package:structogrammar/widgets/menu_bar.dart';

import 'main_view.dart';

class MainPage extends ConsumerWidget {
   MainPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var controller = ref.watch(codePod);
    return Scaffold(
      body:
      AppMenuBar(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height - 20,
          child: ResizableWidget(
            isHorizontalSeparator: false,
            // optional
            isDisabledSmartHide: false,
            // optional
            separatorColor: Colors.white12,
            // optional
            separatorSize: 4,
            // optional
            percentages: [0.7, 0.3],
            // optional
            // onResized: (infoList) =>        // optional
            // print(infoList.map((x) => '(${x.size}, ${x.percentage}%)').join(", ")),
            children: [
              MainView(),
               RightPanel(),
            ],
          ),
        ),
      ),
    );
  }
}


