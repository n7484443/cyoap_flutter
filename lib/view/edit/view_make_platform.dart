import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/view/edit/view_clipboard.dart';
import 'package:cyoap_flutter/view/edit/view_design.dart';
import 'package:cyoap_flutter/view/edit/view_editor.dart';
import 'package:cyoap_flutter/view/edit/view_image_editor.dart';
import 'package:cyoap_flutter/view/edit/view_make.dart';
import 'package:cyoap_flutter/view/edit/view_project_settings.dart';
import 'package:cyoap_flutter/view/edit/view_source.dart';
import 'package:cyoap_flutter/view/util/view_back_dialog.dart';
import 'package:cyoap_flutter/view/view_variable_table.dart';
import 'package:cyoap_flutter/viewModel/edit/vm_editor.dart';
import 'package:cyoap_flutter/viewModel/edit/vm_make_platform.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../../model/platform_system.dart';
import '../../util/custom_snackbar.dart';
import '../../viewModel/edit/vm_draggable_nested_map.dart';
import '../../viewModel/vm_global_setting.dart';
import '../../viewModel/vm_platform.dart';
import '../../viewModel/vm_variable_table.dart';
import '../code/view_ide_line.dart';

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
      () => const ViewIdeLine(),
    ];
    if (ConstList.isMobile()) {
      return PopScope(
        canPop: false,
        child: Scaffold(
          drawer: const ViewEditDrawerMobile(),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Theme.of(context).colorScheme.tertiary,
            unselectedItemColor: Theme.of(context).colorScheme.onSurface,
            items: [
              BottomNavigationBarItem(
                  icon: const Icon(Icons.space_dashboard),
                  label: 'main_dashboard'.i18n),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.layers),
                  label: 'design_settings'.i18n),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.image), label: 'image_settings'.i18n),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.settings),
                  label: 'project_settings'.i18n),
            ],
            onTap: (index) {
              switch (index) {
                case 0:
                  ref
                      .read(changeTabProvider.notifier)
                      .changePageString('viewMake', context);
                  break;
                case 1:
                  ref
                      .read(changeTabProvider.notifier)
                      .changePageString('viewDesignSetting', context);
                  break;
                case 2:
                  ref
                      .read(changeTabProvider.notifier)
                      .changePageString('viewSource', context);
                  break;
                case 3:
                  ref
                      .read(changeTabProvider.notifier)
                      .changePageString('viewProjectSetting', context);
                  break;
              }
              ref.read(bottomTabProvider.notifier).state = index;
            },
            currentIndex: ref.watch(bottomTabProvider),
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
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyS, control: true):
            () async {
          await savePlatform(ref, asZip: getPlatformFileSystem.openAsFile);
          showSnackBar(context, "save_successfully".i18n);
        }
      },
      child: Focus(
        autofocus: true,
        child: PopScope(
          canPop: false,
          child: Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  const ViewSaveIcons(),
                  if (!getPlatformFileSystem.openAsFile)
                    const ViewCompressIcon(),
                  const SizedBox(width: 20),
                  const Expanded(child: SizedBox.shrink()),
                  const BackButton(),
                ],
              ),
            ),
            body: Row(
              children: [
                NavigationRail(
                  destinations: [
                    NavigationRailDestination(
                      icon: const Icon(Icons.space_dashboard),
                      label: Text('vertical_tab_bar_0'.i18n),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.abc),
                      label: Text('vertical_tab_bar_1'.i18n),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.history),
                      label: Text('vertical_tab_bar_2'.i18n),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.layers),
                      label: Text('design_settings'.i18n,
                          textAlign: TextAlign.center),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.image),
                      label: Text('image_settings'.i18n,
                          textAlign: TextAlign.center),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.settings),
                      label: Text('project_settings'.i18n,
                          textAlign: TextAlign.center),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ],
                  labelType: NavigationRailLabelType.all,
                  selectedIndex: ref.watch(sideTabProvider),
                  onDestinationSelected: (int index) {
                    switch (index) {
                      case 3:
                        ref
                            .read(changeTabProvider.notifier)
                            .changePageString('viewDesignSetting', context);
                        break;
                      case 4:
                        ref
                            .read(changeTabProvider.notifier)
                            .changePageString('viewSource', context);
                        break;
                      case 5:
                        ref
                            .read(changeTabProvider.notifier)
                            .changePageString('viewProjectSetting', context);
                        break;
                      default:
                        if (ref.watch(sideTabProvider) == index) {
                          ref.read(sideTabProvider.notifier).state = null;
                        } else {
                          ref.read(sideTabProvider.notifier).state = index;
                        }
                    }
                  },
                ),
                AnimatedSize(
                  duration: ConstList.durationAnimation,
                  child: SizedBox(
                    width: ref.watch(sideTabProvider) == null ? 0 : 250,
                    child: const ViewEditDrawer(),
                  ),
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
        ),
      ),
    );
  }
}

class ViewEditDrawerMobile extends ConsumerStatefulWidget {
  const ViewEditDrawerMobile({super.key});

  @override
  ConsumerState createState() => _ViewEditDrawerMobileState();
}

class _ViewEditDrawerMobileState extends ConsumerState<ViewEditDrawerMobile>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(
                text: 'vertical_tab_bar_0'.i18n,
              ),
              Tab(
                text: 'vertical_tab_bar_1'.i18n,
              ),
              Tab(
                text: 'vertical_tab_bar_2'.i18n,
              ),
            ],
            onTap: (index) {
              ref.read(sideTabProvider.notifier).state = index;
            },
            controller: _tabController,
          ),
          const Expanded(child: ViewEditDrawer()),
          const ViewChangeRotation(),
        ],
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
  final ScrollController _scrollController = ScrollController();

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
    if (ref.watch(sideTabProvider) == 0) {
      return ListView(
        controller: _scrollController,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "search".i18n,
              ),
            ),
          ),
          const NodeTiles(),
        ],
      );
    }
    if (ref.watch(sideTabProvider) == 1) {
      return ListView(
        controller: _scrollController,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "search".i18n,
              ),
            ),
          ),
          const VariableTiles(),
        ],
      );
    }
    if (ref.watch(sideTabProvider) == 2) {
      return const ViewClipboard();
    }
    return const SizedBox.shrink();
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
        if (ref.read(currentProjectChangedProvider)) {
          showDialog(
            context: context,
            builder: (_) => ViewBackDialog(() async {
              final navigator = Navigator.of(context);
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      ViewSaveDialog(asZip: getPlatformFileSystem.openAsFile),
                  barrierDismissible: false);
              await savePlatform(ref, asZip: getPlatformFileSystem.openAsFile);
              navigator.pop();
              ref.read(currentProjectChangedProvider.notifier).save();
            }, (i) {
              Navigator.of(context).pop();
              ref.read(currentProjectChangedProvider.notifier).save();
              if (i != 0) {
                ref.read(nodeEditorTargetPosProvider.notifier).state = null;
                ref.read(lineEditorTargetPosProvider.notifier).state = null;

                ref.read(backupTimerProvider.notifier).stop();
                Navigator.of(context).pushReplacementNamed("/");
              }
            }),
          );
        } else {
          ref.read(nodeEditorTargetPosProvider.notifier).state = null;
          ref.read(lineEditorTargetPosProvider.notifier).state = null;

          ref.read(backupTimerProvider.notifier).stop();
          Navigator.of(context).pushReplacementNamed("/");
        }
      },
    );
  }
}
