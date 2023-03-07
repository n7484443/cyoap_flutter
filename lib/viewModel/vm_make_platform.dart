import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:cyoap_flutter/viewModel/vm_editor.dart';
import 'package:cyoap_flutter/viewModel/vm_project_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view/util/view_back_dialog.dart';

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
          var out = await showDialog(
            context: context,
            builder: (_) => ViewBackDialog(
              () async => ref.read(editorChangeProvider.notifier).save(),
              (i) => Navigator.of(context).pop(i != 0),
              cancelFunction: () =>
                  ref.read(editorChangeProvider.notifier).update(),
            ),
          );
          if (!out) {
            return false;
          }
          refreshLine(ref, ref.read(nodeEditorTargetPosProvider)!.first);
        }
        break;
      case 2:
        if (ref
            .read(valueTypeWrapperListProvider.notifier)
            .isDifferentFromOrigin()) {
          var out = await showDialog(
            context: context,
            builder: (_) => ViewBackDialog(
              () async =>
                  ref.read(valueTypeWrapperListProvider.notifier).save(),
              (i) => Navigator.of(context).pop(i != 0),
              cancelFunction: () {},
            ),
          );
          if (!out) {
            return false;
          }
        }
        break;
    }
    return true;
  }

  void changePage(int index, BuildContext context) {
    removeFunction(state, context).then((value) {
      if (value) {
        entryFunction(index, context);
        state = index;
      }
    });
  }

  void home(BuildContext context) {
    changePage(0, context);
  }

  void changePageString(String name, BuildContext context) {
    var index = tabList.indexOf(name).clamp(0, tabList.length);
    changePage(index, context);
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
