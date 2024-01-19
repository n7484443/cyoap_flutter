import 'dart:io';

import 'package:cyoap_core/playable_platform.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/util/custom_snackbar.dart';
import 'package:cyoap_flutter/view/util/view_back_dialog.dart';
import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../model/device_preference.dart';
import '../model/platform_file_system.dart';
import '../model/platform_system.dart';
import '../viewModel/vm_global_setting.dart';
import '../viewModel/vm_snackbar.dart';
import '../viewModel/vm_start.dart';

class ViewStart extends ConsumerWidget {
  const ViewStart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                          '${'version'.i18n} : ${ref.watch(versionProvider).value ?? ""}'),
                      Visibility(
                        visible: ref.watch(needUpdateStateProvider) != null,
                        child: TextButton(
                          onPressed: () {
                            if (ConstList.isMobile()) {
                              launchUrlString(
                                  'market://details?id=com.clearApple.cyoap_flutter');
                            } else {
                              launchUrlString(
                                  'https://github.com/n7484443/FlutterCyoap/releases');
                            }
                          },
                          child: Text('version_check'.i18n,
                              style: const TextStyle(color: Colors.redAccent)),
                        ),
                      ),
                      Visibility(
                        visible: ref.watch(needUpdateStateProvider) != null,
                        child: Text(
                            'version_latest'.i18n +
                                (ref.watch(needUpdateStateProvider) ?? ''),
                            style: const TextStyle(color: Colors.redAccent)),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                      icon: const Icon(Icons.info),
                      onPressed: () {
                        launchUrlString(
                            'https://github.com/n7484443/cyoap_flutter/wiki');
                      }),
                  IconButton(
                    icon: ref.watch(themeStateProvider) == ThemeMode.light
                        ? const Icon(Icons.dark_mode)
                        : const Icon(Icons.light_mode),
                    onPressed: () {
                      if (ref.watch(themeStateProvider) == ThemeMode.light) {
                        ref.read(themeStateProvider.notifier).state =
                            ThemeMode.dark;
                      } else {
                        ref.read(themeStateProvider.notifier).state =
                            ThemeMode.light;
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.language),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const ViewLanguageDialog(),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const ViewGlobalSettingDialog(),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Expanded(
              flex: 9,
              child: ViewProjectList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: Text('add_file'.i18n),
                  onPressed: () async {
                    if (await ref.read(pathListProvider.notifier).addFile() ==
                        0) {
                      ref.read(pathListSelectedProvider.notifier).state = 0;
                    }
                  },
                ),
                Visibility(
                  visible: !ConstList.isWeb(),
                  child: TextButton(
                    child: Text('add_folder'.i18n),
                    onPressed: () async {
                      if (ConstList.isMobile()) {
                        showDialog(
                          context: context,
                          builder: (context) => const ViewAddProjectDialog(),
                          barrierDismissible: false,
                        );
                      } else {
                        if (await ref
                            .read(pathListProvider.notifier)
                            .addDirectory()) {
                          ref.read(pathListSelectedProvider.notifier).state = 0;
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
            const Divider(
              thickness: 1.5,
            ),
            const SelectMode(),
          ],
        ),
      ),
    );
  }
}

class ViewProjectList extends ConsumerStatefulWidget {
  const ViewProjectList({
    super.key,
  });

  @override
  ConsumerState createState() => _ViewProjectListState();
}

class _ViewProjectListState extends ConsumerState<ViewProjectList> {
  @override
  void initState() {
    super.initState();
    if (!ConstList.isWeb()) {
      ref.read(pathListProvider.notifier).updateFromData().then(
          (value) => ref.read(isLoadingStateProvider.notifier).state = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(isLoadingStateProvider)) {
      return const SizedBox.square(
          dimension: 50, child: CircularProgressIndicator());
    }
    return ListView.builder(
      itemCount: ref.watch(pathListProvider).length,
      itemBuilder: (context, index) {
        return ListTile(
          title: OutlinedButton(
            onPressed: () =>
                ref.read(pathListSelectedProvider.notifier).state = index,
            style: ref.watch(pathListSelectedProvider) == index
                ? OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.lightBlueAccent)
                : null,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(ref.watch(pathListProvider)[index]),
            ),
          ),
          trailing: ConstList.isWeb()
              ? null
              : IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    ref.read(pathListProvider.notifier).removeFrequentPath(
                          index,
                          () async => await showDialog<bool?>(
                            context: context,
                            builder: (_) => ViewWarningDialog(
                              content: 'warning_message_project_delete'.i18n,
                            ),
                          ),
                        );
                  },
                ),
        );
      },
    );
  }
}

class SelectMode extends ConsumerWidget {
  const SelectMode({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () async {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => const ViewLoadingDialog(),
              );
              LoadProjectState loadState =
                  await ref.read(pathListProvider.notifier).openProject();
              Navigator.pop(context);
              switch (loadState.state) {
                case ProjectState.success:
                  getPlatformFileSystem.isEditable = false;
                  Navigator.of(context).pushReplacementNamed('/viewPlay');
                  ref.read(snackBarErrorProvider.notifier).update();
                  break;
                case ProjectState.nonExist:
                  showSnackbar(context, 'failed_load_project_non_exist'.i18n,
                      autoHide: false);
                  break;
                case ProjectState.fail:
                  print(loadState.version!);
                  showSnackbar(
                      context,
                      'failed_load_project_version'
                          .i18n
                          .fill([loadState.version!, fileVersion]),
                      autoHide: false);
                  break;
                default:
                  showSnackbar(context, 'failed_load_project_cyoap_error'.i18n,
                      autoHide: false);
                  break;
              }
            },
            child: Center(
              child: Text(
                'Play',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () async {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => const ViewLoadingDialog(),
              );
              LoadProjectState loadState =
                  await ref.read(pathListProvider.notifier).openProject();
              Navigator.pop(context);
              switch (loadState.state) {
                case ProjectState.success:
                  getPlatformFileSystem.isEditable = true;
                  Navigator.of(context).pushReplacementNamed('/viewMake');
                  break;
                case ProjectState.nonExist:
                  showSnackbar(context, 'failed_load_project_non_exist'.i18n,
                      autoHide: false);
                  break;
                case ProjectState.fail:
                  print(loadState.version!);
                  showSnackbar(
                      context,
                      'failed_load_project_version'
                          .i18n
                          .fill([loadState.version!, fileVersion]),
                      autoHide: false);
                  break;
                default:
                  showSnackbar(context, 'failed_load_project_cyoap_error'.i18n,
                      autoHide: false);
                  break;
              }
            },
            child: Center(
              child: Text(
                'Make',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ViewAddProjectDialog extends ConsumerStatefulWidget {
  const ViewAddProjectDialog({
    super.key,
  });

  @override
  ConsumerState createState() => _ViewAddProjectDialogState();
}

class _ViewAddProjectDialogState extends ConsumerState<ViewAddProjectDialog> {
  TextEditingController? _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("project_name".i18n),
      content: TextField(
        controller: _textEditingController,
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('cancel'.i18n),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.of(context).pop();
            if (_textEditingController?.text.isNotEmpty ?? false) {
              var path = await DevicePreference.getProjectFolder(
                  _textEditingController?.text);
              await Directory(path).create(recursive: true);
              await ref.read(pathListProvider.notifier).updateFromData();
            }
          },
          child: Text('create'.i18n),
        ),
      ],
    );
  }
}

class ViewLoadingDialog extends ConsumerWidget {
  const ViewLoadingDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      scrollable: true,
      content: Column(
        children: [
          const CircularProgressIndicator(),
          Text(ref.watch(loadProjectStateProvider)),
        ],
      ),
    );
  }
}

class ViewLanguageDialog extends ConsumerWidget {
  const ViewLanguageDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      scrollable: true,
      title: Text('language'.i18n),
      content: Column(
        children: ConstList.localeMap.keys
            .map(
              (e) => ListTile(
                title: Text(e),
                onTap: () {
                  I18n.of(context).locale = ConstList.localeMap[e];
                  ref.read(localeStateProvider.notifier).state =
                      ConstList.localeMap[e];
                  DevicePreference.setLocaleName(e);
                  Navigator.of(context).pop();
                },
                selected: ConstList.localeMap[e] == I18n.locale,
              ),
            )
            .toList(),
      ),
    );
  }
}

class ViewGlobalSettingDialog extends ConsumerWidget {
  const ViewGlobalSettingDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var asyncValue = ref.watch(saveAsWebpProvider).value ?? true;
    return AlertDialog(
      scrollable: true,
      title: Text('settings'.i18n),
      content: Column(
        children: [
          ViewSwitchLabel(
            () {
              ref.read(saveAsWebpProvider.notifier).setVariable(!asyncValue);
            },
            asyncValue,
            label: "save_as_webp".i18n,
          ),
          ViewSwitchLabel(
            () {
              ref.read(forceWideProvider.notifier).rev();
            },
            ref.watch(forceWideProvider),
            label: "force_wide".i18n,
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed("/viewLicense");
              },
              child: Text("font_licenses".i18n)),
        ],
      ),
    );
  }
}
