import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../../models/struct.dart';
import '../../riverpod/structs.dart';

class StructShortcutsWidget extends ConsumerWidget {
  const StructShortcutsWidget({super.key, required this.child, required this.onZoomToFit});
  final Function() onZoomToFit;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedStruct = ref.watch(selectedStructPod);
    return CallbackShortcuts(
        bindings: <ShortcutActivator, VoidCallback>{
          const SingleActivator(LogicalKeyboardKey.backspace): () {
            if (selectedStruct != null) {
              globalStructManager.deleteStruct(
                selectedStruct,
              );
            }
          },
          const SingleActivator(LogicalKeyboardKey.keyF, alt: true): () {
           onZoomToFit.call();
          },
          const SingleActivator(LogicalKeyboardKey.digit1, meta: true): () {
            if (selectedStruct != null) {
              globalStructManager.addStructAfter(
                selectedStruct,
                Struct(),
              );
            }
          },
          const SingleActivator(LogicalKeyboardKey.digit2, meta: true): () {
            if (selectedStruct != null) {
              // globalStructManager.addStructAfter(
              //   selectedStruct,
              //   Struct(
              //       type: StructType.ifStatement,
              //       primaryValue: "?",
              //       subStructs: [
              //         Struct(
              //             type: StructType.ifCondition,
              //             primaryValue: "true",
              //             subStructs: [Struct()]),
              //         Struct(
              //             type: StructType.ifCondition,
              //             primaryValue: "false",
              //             subStructs: [Struct()]),
              //       ]),
              // );
            }
          },
          const SingleActivator(LogicalKeyboardKey.digit3, meta: true): () {
            if (selectedStruct != null) {
              globalStructManager.addStructAfter(
                selectedStruct,
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
    const SingleActivator(LogicalKeyboardKey.digit4, meta: true): () {
    if (selectedStruct != null) {
      globalStructManager.addStructAfter(
        selectedStruct,
        Struct(
            type: StructType.forLoop,
            primaryValue: "?",
            subStructs: [Struct()]),
      );
    }
    },
    const SingleActivator(LogicalKeyboardKey.digit5, meta: true): () {
      if (selectedStruct != null) {
        globalStructManager.addStructAfter(
          selectedStruct,
          Struct(
              type: StructType.whileLoop,
              primaryValue: "?",
              subStructs: [Struct()]),
        );
      }
    },
          const SingleActivator(LogicalKeyboardKey.digit6, meta: true): () {
            if (selectedStruct != null) {
              globalStructManager.addStructAfter(
                selectedStruct,
                  Struct(
                      type: StructType.doWhileLoop,
                      primaryValue: "?",
                      subStructs: [Struct()]),
              );
            }
          },
          const SingleActivator(LogicalKeyboardKey.digit7, meta: true): () {
            if (selectedStruct != null) {
              globalStructManager.addStructAfter(
                selectedStruct,
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
          const SingleActivator(LogicalKeyboardKey.digit1,  control: true): () {
            if (selectedStruct != null) {
              globalStructManager.addStructBefore(
                selectedStruct,
                Struct(),
              );
            }
          },
          const SingleActivator(LogicalKeyboardKey.digit2, control: true): () {
            if (selectedStruct != null) {
              // globalStructManager.addStructAfter(
              //   selectedStruct,
              //   Struct(
              //       type: StructType.ifStatement,
              //       primaryValue: "?",
              //       subStructs: [
              //         Struct(
              //             type: StructType.ifCondition,
              //             primaryValue: "true",
              //             subStructs: [Struct()]),
              //         Struct(
              //             type: StructType.ifCondition,
              //             primaryValue: "false",
              //             subStructs: [Struct()]),
              //       ]),
              // );
            }
          },
          const SingleActivator(LogicalKeyboardKey.digit3, control: true): () {
            if (selectedStruct != null) {
              globalStructManager.addStructBefore(
                selectedStruct,
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
          const SingleActivator(LogicalKeyboardKey.digit4, control: true): () {
            if (selectedStruct != null) {
              globalStructManager.addStructBefore(
                selectedStruct,
                Struct(
                    type: StructType.forLoop,
                    primaryValue: "?",
                    subStructs: [Struct()]),
              );
            }
          },
          const SingleActivator(LogicalKeyboardKey.digit5, control: true): () {
            if (selectedStruct != null) {
              globalStructManager.addStructBefore(
                selectedStruct,
                Struct(
                    type: StructType.whileLoop,
                    primaryValue: "?",
                    subStructs: [Struct()]),
              );
            }
          },
          const SingleActivator(LogicalKeyboardKey.digit6, control: true): () {
            if (selectedStruct != null) {
              globalStructManager.addStructBefore(
                selectedStruct,
                Struct(
                    type: StructType.doWhileLoop,
                    primaryValue: "?",
                    subStructs: [Struct()]),
              );
            }
          },
          const SingleActivator(LogicalKeyboardKey.digit7, control: true): () {
            if (selectedStruct != null) {
              globalStructManager.addStructBefore(
                selectedStruct,
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
        },
        child: Focus(
          autofocus: true,
          child: child,
        ));
  }
}
