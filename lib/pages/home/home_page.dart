import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:structogrammar/context_extension.dart';
import 'package:structogrammar/managers/download_manager.dart';
import 'package:structogrammar/models/project.dart';
import 'package:structogrammar/models/tab.dart';
import 'package:structogrammar/pages/home/action_card.dart';
import 'package:structogrammar/pages/home/options_section.dart';
import 'package:structogrammar/riverpod/downloads.dart';
import 'package:structogrammar/riverpod/managers.dart';
import 'package:structogrammar/riverpod/tabs.dart';
import 'package:structogrammar/util/app_colors.dart';
import 'package:structogrammar/util/import_code.dart';
import 'package:structogrammar/util/project.dart';
import 'package:structogrammar/util/tabs.dart';

import '../../models/struct.dart';
import '../../riverpod/projects.dart';
import 'project_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    var projectsStream = ref.watch(projectsPod);
    var tabs = ref.watch(tabsPod);
    return Row(
      children: [
        const OptionsSection(),
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  runAlignment: WrapAlignment.spaceEvenly,
                  runSpacing: 20,
                  children: [
                    ActionCard(
                      onTap: () {},
                      title: "New Structogram",
                      subTitle: "A simple structogram",
                      color: AppColors.primary,
                      icon: Transform.rotate(
                          angle: pi / 2,
                          child: Icon(
                            FontAwesomeIcons.penFancy,
                            color: Colors.white,
                            size: 20,
                          )),
                    ),
                    SizedBox(
                      width: 32,
                    ),
                    ActionCard(
                      onTap: () async {
                        DownloadManager mgr =
                            await ref.read(downloadManagerPod.future);
                        await mgr.download("tree-sitter");
                        await mgr.download("tree-sitter-cpp");
                        List<Struct>? parsed = await importCode();
                        for (int i = 0; i < (parsed?.length ?? 0); i++) {
                          StructHead newStructHead = StructHead(
                            primaryValue: parsed![i].primaryValue,
                            type: parsed[i].type,
                            subStructs: List.from(parsed[i].subStructs),
                            width: 400,
                            structTextStyle: StructTextStyle.functionStyle(),
                          );
                          Project project =
                              await createProject(newStructHead.primaryValue);
                          project.struct.value = newStructHead;
                          var mgr = await ref.read(projectsManagerPod.future);
                          int? id = await mgr.addProject(project);
                          var newTab = createTab(id!);
                          ref.read(tabsPod.notifier).add(newTab);
                          ref.read(selectedTabPod.notifier).state = newTab.tabId;
                        }
                      },
                      title: "Import Code",
                      subTitle: "generate a structogram",
                      color: Colors.orange,
                      icon: Icon(
                        MdiIcons.codeBlockBraces,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    SizedBox(
                      width: 32,
                    ),
                    ActionCard(
                      onTap: () {},
                      title: "Import Project",
                      subTitle: "import a project",
                      color: Colors.grey,
                      icon: Icon(
                        Icons.file_open_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              projectsStream.when(
                  loading: () => Center(
                        child: CircularProgressIndicator(),
                      ),
                  error: (e, s) => Center(
                        child: Text("Something went wrong"),
                      ),
                  data: (projects) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 300,
                                  childAspectRatio: 1.20 / 1,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20),
                          itemCount: projects.length,
                          itemBuilder: (context, i) {
                            return ProjectCard(
                              project: projects[i],
                              onOpen: () {
                                for (int j = 0; j < tabs.length; j++) {
                                  if (tabs[j].projectId == projects[i].id) {
                                    ref.read(selectedTabPod.notifier).state =
                                        tabs[j].tabId;
                                    return;
                                  }
                                }
                                var newTab = createTab(projects[i].id);
                                ref.read(tabsPod.notifier).add(newTab);
                                ref.read(selectedTabPod.notifier).state =
                                    newTab.tabId;
                              },
                              onDelete: () async {
                                var mgr =
                                    await ref.read(projectsManagerPod.future);
                                mgr.deleteProject(projects[i].id);
                                ref
                                    .read(tabsPod.notifier)
                                    .removeByProjectId(projects[i].id);
                              },
                              onNameChanged: (String newName) async {
                                var mgr =
                                    await ref.read(projectsManagerPod.future);
                                Project newProject = projects[i]
                                    .copyWith(projectName: newName.trim());
                                mgr.updateProject(newProject);
                              },
                            );
                          },
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
