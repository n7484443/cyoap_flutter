import 'package:cyoap_flutter/viewModel/vm_code_editor.dart';
import 'package:cyoap_flutter/viewModel/vm_editor.dart';
import 'package:cyoap_flutter/viewModel/vm_global_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view/util/view_back_dialog.dart';
import '../view/view_code_editor.dart';
import '../view/view_design.dart';
import '../view/view_editor.dart';
import '../view/view_font_source.dart';
import '../view/view_global_settings.dart';
import '../view/view_image_editor.dart';
import '../view/view_make.dart';
import '../view/view_source.dart';

final changeTabProvider =
    StateNotifierProvider<ChangeTabNotifier, int>((ref) {
  return ChangeTabNotifier(ref);
});

final tabWidgetProvider = Provider<Widget>((ref) {
  var page = ref.watch(changeTabProvider);
  switch (page) {
    case 1:
      return const ViewEditor();
    case 2:
      return const ViewCodeEditor();
    case 3:
      return const ViewGlobalSetting();
    case 4:
      return const ViewSource();
    case 5:
      return const ViewFontSource();
    case 6:
      return const ViewImageEditor();
    case 7:
      return const ViewDesignSetting();
    default:
      return const ViewMake();
  }
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
        var controller = ref.watch(vmCodeEditorProvider);
        if (ref.read(codeEditorChanged)) {
          var out = await showDialog(
            context: context,
            builder: (_) => ViewBackDialog(
              () => controller.save(),
              () => {},
              cancelFunction: () =>
                  ref.read(codeEditorChanged.notifier).update((state) => false),
            ),
          );
          if (!out) {
            return false;
          }
        }
        break;
      case 3:
        if (ref.read(globalSettingChangedProvider)) {
          var out = await showDialog(
            context: context,
            builder: (_) => ViewBackDialog(
              () => ref.read(vmGlobalSettingProvider.notifier).save(),
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
      case "viewMake":
        return changePage(0, context);
      case "viewEditor":
        return changePage(1, context);
      case "viewCodeEditor":
        return changePage(2, context);
      case "viewGlobalSetting":
        return changePage(3, context);
      case "viewSource":
        return changePage(4, context);
      case "viewFontSource":
        return changePage(5, context);
      case "viewImageEditor":
        return changePage(6, context);
      case "viewDesignSetting":
        return changePage(7, context);
    }
    return changePage(0, context);
  }
}
