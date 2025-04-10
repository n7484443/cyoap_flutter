import 'package:cyoap_flutter/viewModel/edit/vm_editor.dart';
import 'package:cyoap_flutter/viewModel/edit/vm_project_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../code/vm_ide.dart';

final changeTabProvider = StateNotifierProvider<ChangeTabNotifier, int>((ref) {
  return ChangeTabNotifier(ref);
});

class ChangeTabNotifier extends StateNotifier<int> {
  final Ref ref;

  ChangeTabNotifier(this.ref) : super(0);

  void entryFunction(int index, BuildContext context) {
    switch (tabList[index]) {
      case "viewMake":
        ref.read(editEndProvider(ChoiceType.node).notifier).state = false;
        break;
      case "viewEditorLine":
        ref.read(editEndProvider(ChoiceType.line).notifier).state = false;
        break;
    }
  }

  Future<bool> removeFunction(int index, BuildContext context) async {
    switch (tabList[index]) {
      case "viewEditor":
        ref.read(editEndProvider(ChoiceType.node).notifier).state = true;
        break;
      case "viewProjectSetting":
        ref.read(valueTypeWrapperListProvider.notifier).save();
        break;
      case "viewEditorLine":
        ref.read(editEndProvider(ChoiceType.line).notifier).state = true;
        break;
    }
    return true;
  }

  Future<void> changePage(int index, BuildContext context) async {
    var value = await removeFunction(state, context);
    if (value) {
      entryFunction(index, context);
      state = index;
    }
  }

  Future<void> home(BuildContext context) async {
    await changePage(0, context);
  }

  Future<void> changePageString(String name, BuildContext context) async {
    var index = tabList.indexOf(name).clamp(0, tabList.length);
    await changePage(index, context);
  }
}

final List<String> tabList = [
  "viewMake",
  "viewEditor",
  "viewProjectSetting",
  "viewSource",
  "viewImageEditor",
  "viewDesignSetting",
  "viewEditorLine",
];

final List<String> tabBottomList = [
  "viewMake",
  "viewDesignSetting",
  "viewSource",
  "viewProjectSetting",
];

final sideTabProvider = StateProvider<int?>((ref) => null);
final bottomTabProvider = StateProvider<int>((ref) {
  var index = ref.watch(changeTabProvider);
  var name = tabList[index];
  if (tabBottomList.contains(name)) {
    return tabBottomList.indexOf(name);
  }
  return 0;
});
