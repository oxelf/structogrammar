import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:highlight/languages/ini.dart';
import 'package:resizable_widget/resizable_widget.dart';
import 'package:structogrammar/pages/main/left_panel.dart';
import 'package:structogrammar/pages/main/right_panel.dart';
import 'package:structogrammar/riverpod/code_notifier.dart';
import 'package:structogrammar/riverpod/state.dart';
import 'package:structogrammar/widgets/color_picker.dart';
import 'package:structogrammar/widgets/floating_panel.dart';
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
  var colorPicker = ref.watch(colorPickerPod);
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: Stack(

          // onResized: (infoList) {
          //     Future.delayed(Duration(milliseconds: 500),() {
          //       setState(() {
          //         initialized = true;
          //       });ref.read(mainViewWidthPod.notifier).state = infoList[0].size;
          //     });
          //
          // },
          children: [
            MainView(
              height: size.height,
            ),
            Positioned(left: 0, child: FloatingPanel(child: LeftPanel(),left: true, pod: leftFloatingPanelWidthPod,)),
            Positioned(right: 0, child: FloatingPanel(child: RightPanel(), pod: rightFloatingPanelWidthPod,)),
          if (colorPicker != null) FloatingColorPicker()
          ],
        ),
      ),
    );
  }
}
