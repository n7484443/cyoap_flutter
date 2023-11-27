import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:cyoap_flutter/viewModel/vm_editor.dart';
import 'package:cyoap_flutter/viewModel/vm_project_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final changeTabProvider = StateNotifierProvider<ChangeTabNotifier, int>((ref) {
  return ChangeTabNotifier(ref);
});

class ChangeTabNotifier extends StateNotifier<int> {
  final Ref ref;

  ChangeTabNotifier(this.ref) : super(0);

  void entryFunction(int index, BuildContext context) {
    switch (index) {
      case 0:
        ref.read(nodeEditorTargetPosProvider.notifier).state = null;
        break;
    }
  }

  Future<bool> removeFunction(int index, BuildContext context) async {
    switch (index) {
      case 1:
        if (ref.read(editorChangeProvider)) {
          ref.read(editorChangeProvider.notifier).save();
          refreshLine(ref, ref.read(nodeEditorTargetPosProvider)!.first);
        }
        break;
      case 2:
        if (ref
            .read(valueTypeWrapperListProvider.notifier)
            .isDifferentFromOrigin()) {
          ref.read(valueTypeWrapperListProvider.notifier).save();
        }
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
];

final sideTabProvider = StateProvider<int?>((ref) => null);
