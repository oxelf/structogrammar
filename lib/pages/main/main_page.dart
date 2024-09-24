import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/pages/home/home_page.dart';
import 'package:structogrammar/pages/overlay/overlay_page.dart';
import 'package:structogrammar/pages/project/project_page.dart';
import 'package:structogrammar/riverpod/tabs.dart';
import 'package:structogrammar/widgets/app_bar/app_bar.dart';
import 'package:toastification/toastification.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  PageController pageController = PageController();

  @override
  void initState() {
    // FlutterTreeSitter().parseCode('int main() {\n cout << "hello world"; \n}', TreeSitterCpp()).then((value) {
    //   print("parsed: $value");
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tabs = ref.watch(tabsPod);
    var selectedTab = ref.watch(selectedTabPod);
    ref.listen(selectedTabPod, (String? _, String newTabId) {
      var tabs = ref.read(tabsPod);
      int index = tabs.indexWhere((e) => e.tabId == newTabId);
      if (index != -1) {
        pageController.jumpToPage(index);
      } else {
        pageController.jumpToPage(0);
      }
    });
    return OverlayPage(
      child: Scaffold(
          body: Column(
        children: [
          const SAppBar(),
          Expanded(
            child: PageView(
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                for (int i = 0; i < tabs.length; i++)
                  Builder(builder: (context) {
                    if (tabs[i].tabId == "home") {
                      return const HomePage();
                    } else {
                      return ProjectPage(projectId: tabs[i].projectId);
                    }
                  }),
              ],
            ),
          ),
        ],
      )),
    );
  }
}

// WindowTitleBarBox(
// child: Row(
// children: [Expanded(child: MoveWindow()), const WindowButtons()],
// ),
// )
