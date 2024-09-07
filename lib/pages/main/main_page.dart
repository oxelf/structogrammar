import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:highlight/languages/ini.dart';
import 'package:resizable_widget/resizable_widget.dart';
import 'package:structogrammar/pages/main/right_panel.dart';
import 'package:structogrammar/riverpod/code_notifier.dart';
import 'package:structogrammar/riverpod/state.dart';
import 'package:structogrammar/widgets/menu_bar.dart';

import 'main_view.dart';

class MainPage extends ConsumerStatefulWidget {
  MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends ConsumerState<MainPage> {
  double mainViewWidth = 500;
  bool initialized = false;

  @override
  Widget build(BuildContext context) {
    var controller = ref.watch(codePod);
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: AppMenuBar(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height - 20,
          child: ResizableWidget(
            isHorizontalSeparator: (size.height > size.width),
            // optional
            isDisabledSmartHide: false,
            // optional
            separatorColor: Colors.white12,
            // optional
            separatorSize: 4,
            // optional
            percentages: [0.7, 0.3],
            // optional
            onResized: (infoList) {
              print("new size: ${infoList[0].size}");
              if (!initialized) {
                Future.delayed(Duration(milliseconds: 500),() {
                  setState(() {
                    initialized = true;
                  });ref.read(mainViewWidthPod.notifier).state = infoList[0].size;
                });
              } else {
                ref.read(mainViewWidthPod.notifier).state =  infoList[0].size;
              }

            },
            children: [
              MainView(
                height: size.height - 50,
              ),
              RightPanel(),
            ],
          ),
        ),
      ),
    );
  }
}
