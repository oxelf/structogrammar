import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:structogrammar/models/project.dart';
import 'package:super_context_menu/super_context_menu.dart';

import '../../util/app_colors.dart';

class ProjectCard extends StatefulWidget {
  const ProjectCard({
    super.key,
    required this.project,
    required this.onOpen,
    required this.onDelete,
    required this.onNameChanged,
  });

  final Project project;
  final Function() onOpen;
  final Function() onDelete;
  final Function(String) onNameChanged;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool hovered = false;
  bool rename = false;
  TextEditingController textEditingController = TextEditingController();

  @override
  void didUpdateWidget(covariant ProjectCard oldWidget) {
    textEditingController.text = widget.project.projectName ?? "";
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: hovered ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onHover: (_) {
        setState(() {
          hovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          hovered = false;
        });
      },
      child: ContextMenuWidget(
        // force to use dark brightness
        // mobileMenuWidgetBuilder: DefaultMobileMenuWidgetBuilder(brightness: Brightness.dark),
        menuProvider: (_) {
          return Menu(
            children: [
              MenuAction(
                  title: 'delete',
                  callback: () {
                    widget.onDelete.call();
                  },
                  ),
              MenuAction(
                  title: 'rename',
                  callback: () {
                    setState(() {
                      rename = true;
                    });
                  }),
              // MenuSeparator(),
              // Menu(title: 'Submenu', children: [
              //   MenuAction(title: 'Submenu Item 1', callback: () {}),
              //   MenuAction(title: 'Submenu Item 2', callback: () {}),
              //   Menu(title: 'Nested Submenu', children: [
              //     MenuAction(title: 'Submenu Item 1', callback: () {}),
              //     MenuAction(title: 'Submenu Item 2', callback: () {}),
              //   ]),
              // ]),
            ],
          );
        },
        child: GestureDetector(
          onTap: () {
            widget.onOpen.call();
          },
          child: Container(
            decoration: BoxDecoration(
              color: hovered ? AppColors.editorBackground : null,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 125,
                      width: constraints.maxWidth,
                      decoration: BoxDecoration(
                        color: AppColors.editorBackground,
                        border: Border.all(color: AppColors.borderColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: AppColors.editorBackground,
                          child: Image.memory(
                            gaplessPlayback: true,
                            base64Decode(widget.project.imageData ?? ""),
                            errorBuilder: (context, e, s) {
                              return Center(
                                child: Icon(Icons.image),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        (rename)
                            ? SizedBox(
                                width: constraints.maxWidth - 16,
                                child: TextField(
                                  controller: textEditingController,
                                  onEditingComplete: () {
                                    widget.onNameChanged
                                        .call(textEditingController.text);
                                    setState(() {
                                      rename = false;
                                    });
                                  },
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                  decoration: InputDecoration(
                                    constraints: BoxConstraints(maxHeight: 35),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: AppColors.primary),
                                    ),
                                  ),
                                ),
                              )
                            : Text(
                                widget.project.projectName ?? "",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        Text(
                          getLastEdited(
                              widget.project.lastEdited ?? DateTime.now()),
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  String getLastEdited(DateTime date) {
    if (date.isAfter(DateTime.now().subtract(Duration(minutes: 1)))) {
      return "Edited just now";
    }
    int days = DateTime.now().difference(date).inDays;
    int hours = DateTime.now().difference(date).inHours;
    int minutes = DateTime.now().difference(date).inMinutes;
    if (days != 0) {
      return "Edited $days days ago";
    } else if (hours != 0) {
      return "Edited $hours hours ago";
    }
    return "Edited $minutes minutes ago";
  }
}
