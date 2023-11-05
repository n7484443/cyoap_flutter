import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/view/view_choice_node.dart';
import 'package:cyoap_flutter/view/view_draggable_nested_map.dart';
import 'package:cyoap_flutter/view/view_make_platform.dart';
import 'package:cyoap_flutter/viewModel/vm_platform.dart';
import 'package:flutter/material.dart' hide BackButton;
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
      title: Text(asZip ? 'compress_process'.i18n : 'save_process'.i18n),
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

class CopyButton extends ConsumerWidget {
  const CopyButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Visibility(
      visible: ref.watch(copiedChoiceNodeProvider).choiceNode != null,
      child: Draggable<Pos>(
        data: const Pos(data: [copiedPositioned, copiedPositioned]),
        feedback: Transform.scale(
          scale: 0.9,
          child: Opacity(
            opacity: 0.6,
            child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 400,
                ),
                child: const ViewChoiceNode(
                    Pos(data: [copiedPositioned, copiedPositioned]))),
          ),
        ),
        onDragStarted: () {
          ref
              .read(dragChoiceNodeProvider.notifier)
              .dragStart(const Pos(data: [copiedPositioned, copiedPositioned]));
        },
        onDragEnd: (DraggableDetails data) {
          ref.read(dragChoiceNodeProvider.notifier).dragEnd();
        },
        onDragUpdate: (DragUpdateDetails details) => ref
            .read(dragPositionProvider.notifier)
            .state = details.localPosition.dy,
        child: Tooltip(
          message: 'copy_tooltip'.i18n,
          child: const Icon(Icons.paste),
        ),
      ),
    );
  }
}

class RecoverButton extends ConsumerWidget {
  const RecoverButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Visibility(
      visible: ref.watch(removedChoiceNodeProvider).choiceNode != null,
      child: Draggable<Pos>(
        data: const Pos(data: [removedPositioned, removedPositioned]),
        feedback: Transform.scale(
          scale: 0.9,
          child: Opacity(
            opacity: 0.6,
            child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 400,
                ),
                child: const ViewChoiceNode(
                    Pos(data: [removedPositioned, removedPositioned]))),
          ),
        ),
        onDragStarted: () {
          ref.read(dragChoiceNodeProvider.notifier).dragStart(
              const Pos(data: [removedPositioned, removedPositioned]));
        },
        onDragEnd: (DraggableDetails data) {
          ref.read(dragChoiceNodeProvider.notifier).dragEnd();
        },
        onDragUpdate: (DragUpdateDetails details) => ref
            .read(dragPositionProvider.notifier)
            .state = details.localPosition.dy,
        child: Tooltip(
          message: 'recently_tooltip'.i18n,
          child: const Icon(Icons.restore_from_trash),
        ),
      ),
    );
  }
}

class ViewMake extends ConsumerWidget {
  const ViewMake({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ConstList.isSmallDisplay(context)) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: const BackButton(),
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CopyButton(),
                RecoverButton(),
              ],
            ),
            actions: [
              if (ConstList.isMobile()) const ViewRefreshIcons(),
              if (ConstList.isMobile()) const ViewSaveIcons()
            ],
          ),
          body: const NestedScroll(),
        ),
      );
    }
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: const Scaffold(body: NestedScroll()),
    );
  }
}

class ViewRefreshIcons extends ConsumerWidget {
  const ViewRefreshIcons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.refresh),
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
    if (getPlatformFileSystem.openAsFile) {
      return IconButton(
        icon: const Icon(Icons.save),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => const ViewSaveDialog(true),
              barrierDismissible: false);
          savePlatform(ref, true).then((value) => Navigator.of(context).pop());
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
          PopupMenuItem(
            value: 0,
            child: Text('save'.i18n),
          ),
          PopupMenuItem(
            value: 1,
            child: Text('extract'.i18n),
          ),
        ];
      },
    );
  }
}
