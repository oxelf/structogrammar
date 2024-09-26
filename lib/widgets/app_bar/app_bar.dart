import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/context_extension.dart';
import 'package:structogrammar/models/project.dart';
import 'package:structogrammar/models/tab.dart';
import 'package:structogrammar/riverpod/managers.dart';
import 'package:structogrammar/riverpod/projects.dart';
import 'package:structogrammar/riverpod/tabs.dart';
import 'package:structogrammar/util/project.dart';
import 'package:structogrammar/util/tabs.dart';
import 'package:structogrammar/widgets/app_bar/tab.dart';

class SAppBar extends ConsumerStatefulWidget {
  const SAppBar({super.key});

  @override
  ConsumerState createState() => _SAppBarState();
}

class _SAppBarState extends ConsumerState<SAppBar> {
  @override
  Widget build(BuildContext context) {
    var tabs = ref.watch(tabsPod);
    var selectedTab = ref.watch(selectedTabPod);
    var projectsStream = ref.watch(projectsPod);
    return projectsStream.when(
        data: (projects) => Container(
              width: context.width,
              height: 40,
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey)),
              ),
              child: Row(
                children: [
                  if (!kIsWeb && Platform.isMacOS)
                    MoveWindow(
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 60,
                          height: 40,
                        ),
                      ),
                    ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: IntrinsicWidth(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (int i = 0; i < tabs.length; i++)
                              SAppBarTab(
                                onClosed: () {
                                  ref
                                      .read(tabsPod.notifier)
                                      .remove(tabs[i].tabId);
                                  if (tabs.length > 1) {
                                    ref.read(selectedTabPod.notifier).state =
                                        tabs[i - 1].tabId;
                                  } else {
                                    ref.read(selectedTabPod.notifier).state =
                                        "home";
                                  }
                                },
                                onTap: () {
                                  ref.read(selectedTabPod.notifier).state =
                                      tabs[i].tabId;
                                },
                                height: 40,
                                selected: tabs[i].tabId == selectedTab,
                                tab: tabs[i],
                                tabName: (tabs[i].tabId == "home")
                                    ? ""
                                    : nameFromProjects(
                                        tabs[i].projectId, projects),
                                leftBorder: (i == 0),
                              ),
                            IconButton(
                              onPressed: () async {
                                Project newProject =
                                    await createProject(context.l.untitled);
                                var mgr =
                                    await ref.read(projectsManagerPod.future);
                                int? newProjectId =
                                    await mgr.addProject(newProject);
                                if (newProjectId != null) {
                                  STab tab = createTab(newProjectId);
                                  ref.read(tabsPod.notifier).add(tab);
                                  ref.read(selectedTabPod.notifier).state =
                                      tab.tabId;
                                }
                              },
                              icon: const Icon(Icons.add),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        error: (e, s) => const Text("something went wrong"),
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ));
  }

  String nameFromProjects(int projectId, List<Project> projects) {
    for (int i = 0; i < projects.length; i++) {
      if (projects[i].id == projectId) {
        return projects[i].projectName ?? "";
      }
    }
    return context.l.untitled;
  }
}
