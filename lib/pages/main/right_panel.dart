import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/pages/main/edit_panel.dart';
import 'package:structogrammar/parser/cpp_parser.dart';
import 'package:structogrammar/riverpod/code_notifier.dart';
import 'package:structogrammar/riverpod/state.dart';
import 'package:structogrammar/riverpod/structs.dart';

import '../../models/struct.dart';

class RightPanel extends ConsumerStatefulWidget {
  const RightPanel({super.key});
  @override
  ConsumerState createState() => _RightPanelState();
}

class _RightPanelState extends ConsumerState<RightPanel>with TickerProviderStateMixin {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TabController tabController = TabController(length: 2, vsync: this);
      ref.read(tabControllerPod.notifier).state = tabController;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var codeController = ref.watch(codePod);
    var codeInputController = ref.watch(codeInputPod);
    var pageController = PageController();
    var tabController = ref.watch(tabControllerPod);
    Size size = MediaQuery.sizeOf(context);
    return Container(
      height: MediaQuery.sizeOf(context).height,
      decoration: BoxDecoration(
        border: Border(left: BorderSide(width: 2, color: Colors.black)),
      ),
      child: Column(
        children: [
          if (tabController != null) TabBar(controller: tabController,onTap: (index) {
            pageController.jumpToPage(index);
          }, tabs: [
            Tab(text: "Edit",),
            Tab(text: "Output",),
          ]),
          Container(
            height: (size.height > size.width)? null: MediaQuery.sizeOf(context).height - 88,
    width: (size.height > size.width)? null: MediaQuery.sizeOf(context).width,
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: pageController,
              children: [
                EditPanel(),
                CodeTheme(
                  data: CodeThemeData( quoteStyle: TextStyle(color: Colors.green), variableStyle: TextStyle(color: Colors.black), classStyle: TextStyle(color: Colors.black), keywordStyle: TextStyle(color: Colors.orange), functionStyle: TextStyle(color: Colors.red), titleStyle: TextStyle(color: Colors.blue), paramsStyle: TextStyle(color: Colors.black), commentStyle: TextStyle(color: Colors.black), ),
                  child: Container(
                    height: MediaQuery.sizeOf(context).height - 88,
                    child: SingleChildScrollView(
                      child: CodeField(
                        gutterStyle: GutterStyle(
                          showErrors: false,
                          showFoldingHandles: false,
                          showLineNumbers: false,
                        ),
                        textStyle: TextStyle(color: Colors.black),
                        cursorColor: Colors.black,
                        background: Colors.grey.shade200,
                        maxLines: 10000,
                        minLines: 1000,
                        readOnly: true,
                        controller: codeController,
                      ),
                    ),
                  ),
                ),
                // CodeTheme(
                //   data: CodeThemeData( quoteStyle: TextStyle(color: Colors.green), variableStyle: TextStyle(color: Colors.black), classStyle: TextStyle(color: Colors.black), keywordStyle: TextStyle(color: Colors.orange), functionStyle: TextStyle(color: Colors.red), titleStyle: TextStyle(color: Colors.blue), paramsStyle: TextStyle(color: Colors.black), commentStyle: TextStyle(color: Colors.black), ),
                //   child: Container(
                //     height: MediaQuery.sizeOf(context).height - 90,
                //     child: Stack(
                //       children: [
                //         SingleChildScrollView(
                //           child: CodeField(
                //             gutterStyle: GutterStyle(
                //               showErrors: false,
                //               showFoldingHandles: false,
                //               showLineNumbers: false,
                //             ),
                //             textStyle: TextStyle(color: Colors.black),
                //             cursorColor: Colors.black,
                //             background: Colors.grey.shade200,
                //             maxLines: 10000,
                //             minLines: 1000,
                //             controller: codeInputController,
                //           ),
                //         ),
                //         Align(
                //           alignment: Alignment.bottomCenter,
                //           child: Padding(
                //             padding: const EdgeInsets.all(8.0),
                //             child: ElevatedButton(onPressed: () {
                //               // Struct parsed = CppParser.parseCode(codeInputController.fullText);
                //               // print("parsed: $parsed");
                //               // ref.read(structsPod.notifier).addStruct(parsed);
                //             }, style: ButtonStyle(
                //               shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                //             ), child: Text("Generate")),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

