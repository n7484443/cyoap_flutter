import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/view/util/controller_adjustable_scroll.dart';
import 'package:cyoap_flutter/view/util/view_back_dialog.dart';
import 'package:cyoap_flutter/view/util/view_vertical_tabbar.dart';
import 'package:cyoap_flutter/view/view_choice_node.dart';
import 'package:cyoap_flutter/view/view_design.dart';
import 'package:cyoap_flutter/view/view_editor.dart';
import 'package:cyoap_flutter/view/view_image_editor.dart';
import 'package:cyoap_flutter/view/view_make.dart';
import 'package:cyoap_flutter/view/view_project_settings.dart';
import 'package:cyoap_flutter/view/view_source.dart';
import 'package:cyoap_flutter/view/view_variable_table.dart';
import 'package:cyoap_flutter/viewModel/vm_make_platform.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../model/platform_system.dart';
import '../viewModel/vm_choice_node.dart';
import '../viewModel/vm_draggable_nested_map.dart';
import '../viewModel/vm_platform.dart';
import '../viewModel/vm_variable_table.dart';

class ViewMakePlatform extends ConsumerStatefulWidget {
  const ViewMakePlatform({
    super.key,
  });

  @override
  ConsumerState createState() => _ViewMakePlatformState();
}

class _ViewMakePlatformState extends ConsumerState<ViewMakePlatform> {
  @override
  Widget build(BuildContext context) {
    const defaultMap = ViewMake();
    var childrenFunction = [
      () => const ViewEditor(),
      () => const ViewProjectSetting(),
      () => const ViewSource(),
      () => const ViewImageEditor(),
      () => const ViewDesignSetting(),
    ];
    if (ConstList.isSmallDisplay(context)) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          drawer: const Drawer(
            child: ViewEditDrawer(),
          ),
          body: Stack(
            children: [
              defaultMap,
              if (ref.watch(changeTabProvider) != 0)
                childrenFunction[ref.watch(changeTabProvider) - 1]()
            ],
          ),
        ),
      );
    }
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Row(
            children: [
              ViewSaveIcons(),
              SizedBox(width: 10),
              ViewRefreshIcons(),
              Expanded(child: SizedBox.shrink()),
              BackButton(),
            ],
          ),
        ),
        body: Row(
          children: [
            LimitedBox(
              maxWidth: 35,
              child: Column(
                children: [
                  VerticalTabBar(
                      tabList: [
                        'vertical_tab_bar_0'.i18n,
                        'vertical_tab_bar_1'.i18n,
                        'vertical_tab_bar_2'.i18n,
                      ],
                      currentIndex: ref.watch(sideTabProvider),
                      onChange: (index) {
                        ref.read(sideTabProvider.notifier).state = index;
                      }),
                  const Spacer(),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      ref
                          .read(changeTabProvider.notifier)
                          .changePageString('viewDesignSetting', context);
                    },
                    icon: const Icon(Icons.layers),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      ref
                          .read(changeTabProvider.notifier)
                          .changePageString('viewSource', context);
                    },
                    icon: const Icon(Icons.image),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      ref
                          .read(changeTabProvider.notifier)
                          .changePageString('viewProjectSetting', context);
                    },
                    icon: const Icon(Icons.settings),
                  ),
                ],
              ),
            ),
            if (ref.watch(sideTabProvider) != null)
              const SizedBox(
                width: 250,
                child: ViewEditDrawer(),
              ),
            Flexible(
              child: Stack(
                children: [
                  defaultMap,
                  if (ref.watch(changeTabProvider) != 0)
                    childrenFunction[ref.watch(changeTabProvider) - 1]()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewEditDrawer extends ConsumerStatefulWidget {
  const ViewEditDrawer({
    super.key,
  });

  @override
  ConsumerState createState() => _ViewEditDrawerState();
}

class _ViewEditDrawerState extends ConsumerState<ViewEditDrawer> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = AdjustableScrollController();

  @override
  void initState() {
    _controller.addListener(() {
      EasyDebounce.debounce('search', ConstList.debounceDuration, () {
        ref.read(searchProvider.notifier).state = _controller.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    EasyDebounce.cancel('search');
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(sideTabProvider) == 2) {
      return const ViewSideClipboard();
    }
    if (ref.watch(sideTabProvider) == 1) {
      return ListView(
        controller: _scrollController,
        children: [
          const VariableTiles(),
        ],
      );
    }
    if (ref.watch(sideTabProvider) == 0) {
      return ListView(
        controller: _scrollController,
        children: [
          const NodeTiles(),
        ],
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: ListView(
            controller: _scrollController,
            children: [
              const VariableTiles(),
              const NodeTiles(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: "search".i18n,
            ),
          ),
        ),
        if (ConstList.isSmallDisplay(context))
          Column(
            children: [
              ListTile(
                onTap: () {
                  ref
                      .read(changeTabProvider.notifier)
                      .changePageString('viewDesignSetting', context);
                },
                leading: const Icon(Icons.layers),
                title: Text('design_settings'.i18n),
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: Text('image_settings'.i18n),
                onTap: () => ref
                    .read(changeTabProvider.notifier)
                    .changePageString("viewSource", context),
              ),
              ListTile(
                onTap: () {
                  ref
                      .read(changeTabProvider.notifier)
                      .changePageString('viewProjectSetting', context);
                },
                leading: const Icon(Icons.settings),
                title: Text('project_settings'.i18n),
              ),
              const ViewChangeRotation(),
            ],
          ),
      ],
    );
  }
}

class ViewSideClipboard extends ConsumerStatefulWidget {
  const ViewSideClipboard({super.key});

  @override
  ConsumerState createState() => _ViewSideClipboardState();
}

class _ViewSideClipboardState extends ConsumerState<ViewSideClipboard> {
  @override
  Widget build(BuildContext context) {
    var list = [];
    if (ref.watch(copiedChoiceNodeProvider).choiceNode != null) {
      list.add(const Pos(data: [copiedPositioned, copiedPositioned]));
    }
    if (ref.watch(removedChoiceNodeProvider).choiceNode != null) {
      list.add(const Pos(data: [removedPositioned, removedPositioned]));
    }
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        var pos = list[index];
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Draggable<Pos>(
            data: pos,
            feedback: Transform.scale(
              scale: 0.9,
              child: Opacity(
                opacity: 0.6,
                child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                    ),
                    child: ViewChoiceNode(
                      pos,
                      ignoreChild: true,
                    )),
              ),
            ),
            onDragStarted: () {
              ref.read(dragChoiceNodeProvider.notifier).dragStart(pos);
            },
            onDragEnd: (DraggableDetails data) {
              ref.read(dragChoiceNodeProvider.notifier).dragEnd();
            },
            onDragUpdate: (DragUpdateDetails details) => ref
                .read(dragPositionProvider.notifier)
                .state = details.localPosition.dy,
            child: ViewChoiceNode(pos, ignoreChild: true),
          ),
        );
      },
      itemCount: list.length,
    );
  }
}

class BackButton extends ConsumerWidget {
  const BackButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      tooltip: 'back'.i18n,
      icon: const Icon(Icons.close),
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
    );
  }
}
