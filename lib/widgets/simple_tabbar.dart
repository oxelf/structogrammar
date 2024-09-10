import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SimpleTabbar extends ConsumerWidget {
  const SimpleTabbar({super.key, required this.tabs, required this.currentTabpod});
  final List<String> tabs;
  final StateProvider<String> currentTabpod;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var tab = ref.watch(currentTabpod);
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 8),
      child: Row(
        children: [
          for (int i = 0; i < tabs.length; i++) GestureDetector(
            onTap: () {
              ref.read(currentTabpod.notifier).state = tabs[i];
            },
            child: Container(decoration: BoxDecoration(
             color: (tabs[i] == tab)? Color.fromRGBO(245, 245, 245, 1): null,
              borderRadius: BorderRadius.circular(4),
            ), child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:  8.0, vertical: 3),
              child: Text(tabs[i]),
            ),),
          ),
        ],
      ),
    );
  }
}
