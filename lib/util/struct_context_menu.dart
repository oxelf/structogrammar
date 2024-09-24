import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/context_extension.dart';
import 'package:structogrammar/main.dart';
import 'package:structogrammar/models/struct.dart';
import 'package:super_context_menu/super_context_menu.dart';

import '../riverpod/structs.dart';

getStructContextMenu(MenuRequest r, Struct struct, BuildContext context,
    WidgetRef ref) {
  print("context menu for: ${struct.id}");
  int addInside = -1;
  // check if the struct is something where we can add inside and the specific substruct if there
  switch (struct.type) {
    case StructType.forLoop:
      addInside = struct.id ?? -1;
    case StructType.whileLoop:
      addInside = struct.id ?? -1;
    case StructType.doWhileLoop:
      addInside = struct.id ?? -1;
    default:
  }
  return Menu(
    children: [
      MenuAction(
          title: context.l.copy,
          callback: () {
            ref.read(structCopyPod.notifier).state = struct;
          },
          state: MenuActionState.none,
          activator: const SingleActivator(
            LogicalKeyboardKey.keyC,
            meta: true,
          )),
      MenuAction(
          title: context.l.paste,
          callback: () {
            Struct? copy = ref.read(structCopyPod);
            if (copy != null && struct.id != null) {
             copy = copy.copy();
              globalStructManager.addStructAfter(struct.id!, copy);
            }
          },
          activator: const SingleActivator(
            LogicalKeyboardKey.keyV,
            meta: true,
          )),
      MenuAction(
          title: context.l.delete,
          callback: () {
            if (struct.id != null) globalStructManager.deleteStruct(struct.id!);
          },
          activator: const SingleActivator(
            LogicalKeyboardKey.backspace,
          )),
      MenuSeparator(),
      Menu(title: context.l.add, children: [
        Menu(
          title: context.l.before,
          children: [
            MenuAction(
                title: context.l.instruction,
                callback: () {
                  if (struct.id != null) {
                    globalStructManager.addStructBefore(
                      struct.id!,
                      Struct(),
                    );
                  }
                },
                activator: const SingleActivator(
                  LogicalKeyboardKey.digit1,
                  control: true,
                )),
            MenuAction(
                title: context.l.ifStatement,
                callback: () {
                  if (struct.id != null) {
                    globalStructManager.addStructBefore(
                      struct.id!,
                      Struct(
                          type: StructType.ifStatement,
                          primaryValue: "?",
                          subStructs: [
                            Struct(
                                type: StructType.ifCondition,
                                primaryValue: "true",
                                subStructs: [Struct()]),
                            Struct(
                                type: StructType.ifCondition,
                                primaryValue: "false",
                                subStructs: [Struct()]),
                          ]),
                    );
                  }
                },
                activator: const SingleActivator(
                  LogicalKeyboardKey.digit2,
                  control: true,
                )),
            MenuAction(
                title: context.l.caseStatement,
                callback: () {},
                activator: const SingleActivator(
                  LogicalKeyboardKey.digit3,
                   control: true,
                )),
            MenuAction(
                title: context.l.forLoop,
                callback: () {
                  if (struct.id != null) {
                    globalStructManager.addStructBefore(
                      struct.id!,
                      Struct(
                          type: StructType.forLoop,
                          primaryValue: "?",
                          subStructs: [Struct()]),
                    );
                  }
                },
                activator: const SingleActivator(
                  LogicalKeyboardKey.digit4,
                  control: true,
                )),
            MenuAction(
                title: context.l.whileLoop,
                callback: () {
                  if (struct.id != null) {
                    globalStructManager.addStructBefore(
                      struct.id!,
                      Struct(
                          type: StructType.whileLoop,
                          primaryValue: "?",
                          subStructs: [Struct()]),
                    );
                  }
                },
                activator: const SingleActivator(
                  LogicalKeyboardKey.digit5,
                  control: true,
                )),
            MenuAction(
                title: context.l.repeat,
                callback: () {
                  if (struct.id != null) {
                    globalStructManager.addStructBefore(
                      struct.id!,
                      Struct(
                          type: StructType.doWhileLoop,
                          primaryValue: "?",
                          subStructs: [Struct()]),
                    );
                  }
                },
                activator: const SingleActivator(
                  LogicalKeyboardKey.digit6,
                   control: true,
                )),
            MenuAction(
                title: context.l.tryStatement,
                callback: () {
                  if (struct.id != null) {
                    globalStructManager.addStructBefore(
                      struct.id!,
                      Struct(
                          type: StructType.tryStatement,
                          primaryValue: "?",
                          subStructs: [
                            Struct(),
                            Struct(
                              type: StructType.catchStatement,
                              primaryValue: "",
                              subStructs: [Struct()],
                            )
                          ]),
                    );
                  }
                },
                activator: const SingleActivator(
                  LogicalKeyboardKey.digit7,
                   control: true,
                )),
          ],
        ),
        Menu(title: context.l.after, children: [
          MenuAction(
              title: context.l.instruction,
              callback: () {
                if (struct.id != null) {
                  globalStructManager.addStructAfter(
                    struct.id!,
                    Struct(),
                  );
                }
              },
              activator: const SingleActivator(
                LogicalKeyboardKey.digit1,
                meta: true,
              )),
          MenuAction(
              title: context.l.ifStatement,
              callback: () {
                if (struct.id != null) {
                  globalStructManager.addStructAfter(
                    struct.id!,
                    Struct(
                        type: StructType.ifStatement,
                        primaryValue: "?",
                        subStructs: [
                          Struct(
                              type: StructType.ifCondition,
                              primaryValue: "true",
                              subStructs: [Struct()]),
                          Struct(
                              type: StructType.ifCondition,
                              primaryValue: "false",
                              subStructs: [Struct()]),
                        ]),
                  );
                }
              },
              activator: const SingleActivator(
                LogicalKeyboardKey.digit2,
                meta: true,
              )),
          MenuAction(
              title: context.l.caseStatement,
              callback: () {},
              activator: const SingleActivator(
                LogicalKeyboardKey.digit3,
                meta: true,
              )),
          MenuAction(
              title: context.l.forLoop,
              callback: () {
                if (struct.id != null) {
                  globalStructManager.addStructAfter(
                    struct.id!,
                    Struct(
                        type: StructType.forLoop,
                        primaryValue: "?",
                        subStructs: [Struct()]),
                  );
                }
              },
              activator: const SingleActivator(
                LogicalKeyboardKey.digit4,
                meta: true,
              )),
          MenuAction(
              title: context.l.whileLoop,
              callback: () {
                if (struct.id != null) {
                  globalStructManager.addStructAfter(
                    struct.id!,
                    Struct(
                        type: StructType.whileLoop,
                        primaryValue: "?",
                        subStructs: [Struct()]),
                  );
                }
              },
              activator: const SingleActivator(
                LogicalKeyboardKey.digit5,
                meta: true,
              )),
          MenuAction(
              title: context.l.repeat,
              callback: () {
                if (struct.id != null) {
                  globalStructManager.addStructAfter(
                    struct.id!,
                    Struct(
                        type: StructType.doWhileLoop,
                        primaryValue: "?",
                        subStructs: [Struct()]),
                  );
                }
              },
              activator: const SingleActivator(
                LogicalKeyboardKey.digit6,
                meta: true,
              )),
          MenuAction(
              title: context.l.tryStatement,
              callback: () {
                if (struct.id != null) {
                  globalStructManager.addStructAfter(
                    struct.id!,
                    Struct(
                        type: StructType.tryStatement,
                        primaryValue: "?",
                        subStructs: [
                          Struct(),
                          Struct(
                            type: StructType.catchStatement,
                            primaryValue: "",
                            subStructs: [Struct()],
                          )
                        ]),
                  );
                }
              },
              activator: const SingleActivator(
                LogicalKeyboardKey.digit7,
                meta: true,
              )),
        ]),
        if (addInside != -1)
          Menu(
            title: context.l.addInside,
            children: [],
          ),
      ]),
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
}
