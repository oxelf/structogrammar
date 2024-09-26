import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/models/tab.dart';

class TabsNotifier extends Notifier<List<STab>> {
  @override
  List<STab> build() {
    return [
      STab(
          tabId: "home",
          projectId: -1,
          icon: const Icon(Icons.home_outlined),
          closable: false),
    ];
  }

  void add(STab tab) {
    state = [...state, tab];
  }

  void remove(String tabId) {
    List<STab> tabs = state;
    tabs.removeWhere((e) => e.tabId == tabId);
    state = [...tabs];
  }

  void removeByProjectId(int projectId) {
    List<STab> tabs = state;
    tabs.removeWhere((e) => e.projectId == projectId);
    state = [...tabs];
  }
}

final tabsPod = NotifierProvider<TabsNotifier, List<STab>>(() {
  return TabsNotifier();
});

final selectedTabPod = StateProvider<String>((ref) {
  return "home";
});
