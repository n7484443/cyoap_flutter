import 'dart:io';

import 'package:cyoap_core/playable_platform.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/util/custom_snackbar.dart';
import 'package:cyoap_flutter/view/util/view_back_dialog.dart';
import 'package:cyoap_flutter/view/util/view_switch_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_extension/i18n_extension.dart';
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${'version'.i18n} : ${ref.watch(versionProvider).value ?? ""} | ${'version_latest'.i18n} : ${ref.watch(needUpdateStateProvider) ?? ''}',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
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
                              child: Text('version_check'.i18n),
                            ),
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
                          if (ref.watch(themeStateProvider) ==
                              ThemeMode.light) {
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
                            builder: (context) =>
                                const ViewGlobalSettingDialog(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const Expanded(
                flex: 9,
                child: Card(child: ViewProjectList()),
              ),
              SizedBox(
                height: 68,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              child: Text('add_file'.i18n),
                              onPressed: () async {
                                if (await ref
                                        .read(
                                            frequentlyUsedPathProvider.notifier)
                                        .addFile() ==
                                    0) {
                                  ref
                                      .read(pathListSelectedProvider.notifier)
                                      .state = 0;
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Visibility(
                              visible: !ConstList.isWeb(),
                              child: TextButton(
                                child: Text('add_folder'.i18n),
                                onPressed: () async {
                                  if (ConstList.isMobile()) {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          const ViewAddProjectDialog(),
                                      barrierDismissible: false,
                                    );
                                  } else if (await ref
                                      .read(frequentlyUsedPathProvider.notifier)
                                      .addDirectory()) {
                                    ref
                                        .read(pathListSelectedProvider.notifier)
                                        .state = ref
                                            .read(frequentlyUsedPathProvider)
                                            .length -
                                        1;
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                        child: Row(
                      children: [
                        const SelectModeButton(isPlay: true),
                        if (ConstList.isSmallDisplay(context))
                          const Padding(padding: EdgeInsets.all(8.0)),
                        const SelectModeButton(isPlay: false),
                      ],
                    )),
                  ],
                ),
              ),
            ],
          ),
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
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      controller: _scrollController,
      child: ListView.builder(
        itemCount: ref.watch(frequentlyUsedPathProvider).length,
        controller: _scrollController,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: FilterChip.elevated(
              onSelected: (bool value) {
                if(ref.read(pathListSelectedProvider) != index){
                  ref.read(pathListSelectedProvider.notifier).state = index;
                }else{
                  ref.read(pathListSelectedProvider.notifier).state = -1;
                }
              },
              selected: ref.watch(pathListSelectedProvider) == index,
              label: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(ref.watch(frequentlyUsedPathProvider)[index]),
                ),
              ),
              onDeleted: () {
                ref
                    .read(frequentlyUsedPathProvider.notifier)
                    .removeFrequentPath(
                      index,
                      () async => await showDialog<bool?>(
                        context: context,
                        builder: (_) => ViewWarningDialog(
                          content: 'warning_message_project_delete'.i18n,
                        ),
                      ),
                    );
              },
              deleteIcon: const Icon(Icons.delete),
            ),
          );
        },
      ),
    );
  }
}

class SelectModeButton extends ConsumerWidget {
  final bool isPlay;

  const SelectModeButton({required this.isPlay, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () async {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => const ViewLoadingDialog(),
        );
        if (!isPlay) {
          ref.read(backupTimerProvider.notifier).start();
        }
        LoadProjectState loadState =
            await ref.read(frequentlyUsedPathProvider.notifier).openProject();
        Navigator.pop(context);
        switch (loadState.state) {
          case ProjectState.success:
            if (isPlay) {
              getPlatformFileSystem.isEditable = false;
              Navigator.of(context).pushReplacementNamed('/viewPlay');
              ref.read(snackBarErrorProvider.notifier).update();
            } else {
              getPlatformFileSystem.isEditable = true;
              Navigator.of(context).pushReplacementNamed('/viewEdit');
            }
            break;
          case ProjectState.nonExist:
            showSnackBar(context, 'failed_load_project_non_exist'.i18n,
                autoHide: false);
            break;
          case ProjectState.fail:
            print(loadState.version!);
            showSnackBar(
                context,
                'failed_load_project_version'
                    .i18n
                    .fill([loadState.version!, fileVersion]),
                autoHide: false);
            break;
          case ProjectState.nonSelected:
            if (isPlay) {
              showSnackBar(context, 'failed_load_project_non_exist'.i18n,
                  autoHide: false);
            }else{
              getPlatformFileSystem.isEditable = true;
              getPlatformFileSystem.openAsFile = true;
              Navigator.of(context).pushReplacementNamed('/viewEdit');
              getPlatformFileSystem.path = null;
            }
            break;
          default:
            showSnackBar(context, 'failed_load_project_cyoap_error'.i18n,
                autoHide: false);
            break;
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          isPlay ? 'Play' : 'Edit',
          textAlign: TextAlign.center,
          style: ConstList.isSmallDisplay(context)
              ? Theme.of(context).textTheme.titleLarge
              : Theme.of(context).textTheme.displaySmall,
        ),
      ),
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
              ref.read(frequentlyUsedPathProvider.notifier).addPath(path);
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
        children: DevicePreference.localeMap.keys
            .map(
              (name) => ListTile(
                title: Text(DevicePreference.localeMap[name]!),
                onTap: () {
                  ref.read(localeStateProvider.notifier).state = Locale(name);
                  I18n.of(context).locale = Locale(name);
                  Navigator.of(context).pop();
                },
                selected: name == I18n.locale.toString().toLowerCase(),
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
    var asyncValue = ref.watch(saveAsWebpProvider);
    return AlertDialog(
      scrollable: true,
      title: Text('settings'.i18n),
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(ConstList.padding),
            child: ViewSwitchLabel(
              () {
                ref.read(saveAsWebpProvider.notifier).rev();
              },
              asyncValue,
              label: "save_as_webp".i18n,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(ConstList.padding),
            child: ViewSwitchLabel(
              () {
                ref.read(forceWideProvider.notifier).rev();
              },
              ref.watch(forceWideProvider),
              label: "force_wide".i18n,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(ConstList.padding),
            child: IntSettingInput(
              text: 'backup_frequency'.i18n,
              initialValue: ref.read(backupFrequencyProvider),
              onChanged: (value) {
                ref.read(backupFrequencyProvider.notifier).setVariable(value);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(ConstList.padding),
            child: IntSettingInput(
              text: 'clipboard_maximum'.i18n,
              initialValue: ref.read(clipboardMaximumCapacityProvider),
              onChanged: (value) {
                ref
                    .read(clipboardMaximumCapacityProvider.notifier)
                    .setVariable(value);
              },
            ),
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

class IntSettingInput extends ConsumerStatefulWidget {
  final String text;
  final int textLength;
  final int initialValue;
  final void Function(int afterValue) onChanged;

  const IntSettingInput(
      {required this.text,
      this.textLength = 3,
      required this.initialValue,
      required this.onChanged,
      super.key});

  @override
  ConsumerState createState() => _IntSettingInputState();
}

class _IntSettingInputState extends ConsumerState<IntSettingInput> {
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue.toString());
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(widget.text),
        Expanded(
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            maxLength: widget.textLength,
            decoration: const InputDecoration(
              isDense: true,
              isCollapsed: true,
              counterText: '',
            ),
            textAlign: TextAlign.right,
            onChanged: (String value) {
              var t = int.tryParse(value);
              if (t != null) {
                widget.onChanged(t);
              }
            },
          ),
        ),
      ],
    );
  }
}
