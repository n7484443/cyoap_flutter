import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/view/util/view_back_dialog.dart';
import 'package:cyoap_flutter/view/view_choice_node.dart';
import 'package:cyoap_flutter/view/view_draggable_nested_map.dart';
import 'package:cyoap_flutter/viewModel/vm_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../model/platform_system.dart';
import '../viewModel/vm_choice_node.dart';
import '../viewModel/vm_draggable_nested_map.dart';
import '../viewModel/vm_editor.dart';
import '../viewModel/vm_make_platform.dart';
import '../viewModel/vm_project_setting.dart';

class ViewSaveDialog extends ConsumerWidget {
  final bool asZip;

  const ViewSaveDialog(
    this.asZip, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text(asZip ? 'compress_process'.i18n : 'save_process'.i18n ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          Text(ref.watch(stopWatchProvider)),
        ],
      ),
    );
  }
}

class ViewMake extends ConsumerWidget {
  const ViewMake({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var appbarWidget = AppBar(
      leading: IconButton(
        tooltip: 'back'.i18n,
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          if (ref.read(draggableNestedMapChangedProvider)) {
            showDialog(
              context: context,
              builder: (_) => ViewBackDialog(() async {
                final navigator = Navigator.of(context);
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        ViewSaveDialog(getPlatformFileSystem.openAsFile),
                    barrierDismissible: false);
                await savePlatform(ref, getPlatformFileSystem.openAsFile);
                navigator.pop();
                ref.read(draggableNestedMapChangedProvider.notifier).state =
                    false;
              }, (i) {
                Navigator.of(context).pop();
                if (i != 0) {
                  Navigator.of(context).pushReplacementNamed("/");
                }
              }),
            );
          } else {
            Navigator.of(context).pushReplacementNamed("/");
          }
        },
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Visibility(
            visible: ref.watch(removedChoiceNode) != null,
            child: Draggable<Pos>(
              data: Pos(data: [removedPositioned, removedPositioned]),
              feedback: Transform.scale(
                scale: 0.9,
                child: Opacity(
                  opacity: 0.6,
                  child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 400,
                      ),
                      child: ViewChoiceNode(
                          Pos(data: [removedPositioned, removedPositioned]))),
                ),
              ),
              onDragStarted: () {
                ref.read(dragChoiceNodeProvider.notifier).dragStart(
                    Pos(data: [removedPositioned, removedPositioned]));
              },
              onDragEnd: (DraggableDetails data) {
                ref.read(dragChoiceNodeProvider.notifier).dragEnd();
              },
              onDragUpdate: (DragUpdateDetails details) => ref
                  .read(dragPositionProvider.notifier)
                  .state = details.localPosition.dy,
              child: Tooltip(
                message: 'recently_tooltip'.i18n,
                child: const Icon(Icons.paste),
              ),
            ),
          ),
        ],
      ),
      actions: [
        if (ConstList.isMobile()) const ViewRefreshIcons(),
        if (ConstList.isMobile()) const ViewSaveIcons()
      ],
    );

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: appbarWidget,
        body: const NestedScroll(),
      ),
    );
  }
}

class ViewRefreshIcons extends ConsumerWidget {
  const ViewRefreshIcons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.play_arrow),
      tooltip: 'update_variable_tooltip'.i18n,
      onPressed: () {
        getPlatform.generateRecursiveParser();
        getPlatform.updateStatusAll();
      },
    );
  }
}

class ViewSaveIcons extends ConsumerWidget {
  const ViewSaveIcons({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var current = tabList[ref.watch(changeTabProvider)];
    if (current == "viewEditor") {
      return IconButton(
        icon: const Icon(Icons.save),
        onPressed: () {
          ref.read(editorChangeProvider.notifier).save();
        },
      );
    }
    if (current == "viewProjectSetting") {
      return IconButton(
        icon: const Icon(Icons.save),
        onPressed: () {
          ref.read(valueTypeWrapperListProvider.notifier).save();
        },
      );
    }
    return PopupMenuButton(
      icon: const Icon(Icons.save),
      tooltip: 'save_option'.i18n,
      onSelected: (int selected) {
        showDialog(
            context: context,
            builder: (BuildContext context) => ViewSaveDialog(selected != 0),
            barrierDismissible: false);
        switch (selected) {
          case 0:
            savePlatform(ref, false)
                .then((value) => Navigator.of(context).pop());
            break;
          case 1:
            savePlatform(ref, true)
                .then((value) => Navigator.of(context).pop());
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          if (!getPlatformFileSystem.openAsFile)
            PopupMenuItem(
              value: 0,
              child: Text('save'.i18n),
            ),
          PopupMenuItem(
            value: 1,
            child: Text(
                'extract'.i18n),
          ),
        ];
      },
    );
  }
}
