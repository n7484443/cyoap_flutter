import 'package:cyoap_core/grammar/analyser.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/util/custom_snackbar.dart';
import 'package:cyoap_flutter/view/choice/view_choice_page.dart';
import 'package:cyoap_flutter/view/edit/view_make_platform.dart';
import 'package:cyoap_flutter/viewModel/vm_platform.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../../model/platform_system.dart';

class ViewSaveDialog extends ConsumerWidget {
  final bool asZip;

  const ViewSaveDialog({
    required this.asZip,
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

class ViewMake extends ConsumerWidget {
  const ViewMake({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ConstList.isMobile()) {
      return PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const ViewSaveIcons(),
                if (!getPlatformFileSystem.openAsFile) const ViewCompressIcon(),
              ],
            ),
            actions: [
              const BackButton(),
            ],
          ),
          body: const ViewChoicePage(),
        ),
      );
    }
    return const PopScope(
      canPop: false,
      child: Scaffold(body: ViewChoicePage()),
    );
  }
}

class ViewCompressIcon extends ConsumerWidget {
  const ViewCompressIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
        tooltip: 'extract'.i18n,
        onPressed: () async {
          showDialog(context: context, builder: (BuildContext context) => const ViewSaveDialog(asZip: true), barrierDismissible: false);
          await savePlatform(ref, asZip: true);
          showSnackBar(context, 'save_successfully'.i18n, ref: ref, errorLog: Analyser().errorList, autoHide: true);
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.folder_zip));
  }
}

class ViewSaveIcons extends ConsumerWidget {
  const ViewSaveIcons({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      tooltip: 'save'.i18n,
      icon: const Icon(Icons.save),
      onPressed: () async {
        showDialog(context: context, builder: (BuildContext context) => ViewSaveDialog(asZip: getPlatformFileSystem.openAsFile), barrierDismissible: false);
        await savePlatform(ref, asZip: getPlatformFileSystem.openAsFile);
        Navigator.of(context).pop();
        showSnackBar(context, "save_successfully".i18n, ref: ref, errorLog: Analyser().errorList, autoHide: true);
      },
    );
  }
}
