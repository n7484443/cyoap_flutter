import 'dart:io';

import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/view/util/view_back_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../model/opening_file_folder.dart';
import '../model/platform_system.dart';
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
              alignment: Alignment.topRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('version : ${ref.watch(versionProvider).value ?? ""}'),
                  Visibility(
                    visible: ref.watch(needUpdateStateProvider),
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
                      child: const Text('새로운 버전이 나왔습니다!',
                          style: TextStyle(color: Colors.redAccent)),
                    ),
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
                  child: const Text('파일 추가'),
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
                    child: const Text('폴더 추가'),
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
      ref.read(pathListProvider.notifier).updatePathList().then(
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
                            builder: (_) => const ViewWarningDialog(),
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
            onTap: () {
              ref.read(pathListProvider.notifier).openProject().then((value) {
                if (value) {
                  getPlatformFileSystem.isEditable = false;
                  Navigator.of(context).pushReplacementNamed('/viewPlay');
                  ref.read(snackBarErrorProvider.notifier).update();
                }
              });
            },
            child: Center(
              child: Text(
                'Play',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              ref.read(pathListProvider.notifier).openProject().then((value) {
                if (value) {
                  getPlatformFileSystem.isEditable = true;
                  Navigator.of(context).pushReplacementNamed('/viewMake');
                }
              });
            },
            child: Center(
              child: Text(
                'Make',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1,
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
      title: const Text("프로젝트명"),
      content: TextField(
        controller: _textEditingController,
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.of(context).pop();
            var path = await ProjectPath.getProjectFolder(
                _textEditingController?.text);
            await Directory(path).create(recursive: true);
            await ref.read(pathListProvider.notifier).updatePathList();
          },
          child: const Text('생성'),
        ),
      ],
    );
  }
}
