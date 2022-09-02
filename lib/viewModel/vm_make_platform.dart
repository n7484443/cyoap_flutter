import 'package:cyoap_flutter/viewModel/vm_editor.dart';
import 'package:cyoap_flutter/viewModel/vm_global_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view/util/view_back_dialog.dart';

final changeTabProvider = StateNotifierProvider<ChangeTabNotifier, int>((ref) {
  return ChangeTabNotifier(ref);
});

class ChangeTabNotifier extends StateNotifier<int> {
  final Ref ref;
  ChangeTabNotifier(this.ref) : super(0);
  List<int> stack = List.empty(growable: true);

  Future<bool> removeFunction(int index, BuildContext context) async {
    switch (index) {
      case 1:
        if (ref.read(changeProvider)) {
          var out = await showDialog(
            context: context,
            builder: (_) => ViewBackDialog(
              () => ref.read(changeProvider.notifier).save(),
              () => {},
              cancelFunction: () => ref.read(changeProvider.notifier).update(),
            ),
          );
          if (!out) {
            return false;
          }
        }
        break;
      case 2:
        if (ref.read(globalSettingChangedProvider)) {
          var out = await showDialog(
            context: context,
            builder: (_) => ViewBackDialog(
              () => ref.read(valueTypeWrapperListProvider.notifier).save(),
              () => {},
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
        state = index;
        if (stack.isEmpty || stack.last != index) {
          stack.add(index);
        }
      }
    });
  }

  void back(BuildContext context) {
    if (stack.length <= 1) {
      changePage(0, context);
      stack.clear();
    } else {
      removeFunction(state, context).then((value) {
        if (value) {
          stack.removeLast();
          state = stack.last;
        }
      });
    }
  }

  void changePageString(String index, BuildContext context) {
    switch (index) {
      case "viewEditor":
        return changePage(1, context);
      case "viewGlobalSetting":
        return changePage(2, context);
      case "viewSource":
        return changePage(3, context);
      case "viewFontSource":
        return changePage(4, context);
      case "viewImageEditor":
        return changePage(5, context);
      case "viewDesignSetting":
        return changePage(6, context);
      default:
        return changePage(0, context);
    }
  }
}
