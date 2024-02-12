import 'package:cyoap_core/grammar/analyser.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/util/custom_snackbar.dart';
import 'package:cyoap_flutter/view/choice/view_choice_page.dart';
import 'package:cyoap_flutter/view/view_make_platform.dart';
import 'package:cyoap_flutter/viewModel/vm_platform.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../model/platform_system.dart';

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

class ViewMake extends ConsumerWidget {
  const ViewMake({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ConstList.isMobile()) {
      return PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ViewSaveIcons(),
                ViewRefreshIcons(),
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

class ViewRefreshIcons extends ConsumerWidget {
  const ViewRefreshIcons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.refresh),
      tooltip: 'update_variable_tooltip'.i18n,
      onPressed: () {
        getPlatform.generateRecursiveParser();
        getPlatform.updateStatus();
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
    if (getPlatformFileSystem.openAsFile) {
      return IconButton(
        icon: const Icon(Icons.save),
        onPressed: () async {
          showDialog(
              context: context,
              builder: (BuildContext context) => const ViewSaveDialog(true),
              barrierDismissible: false);
          await savePlatform(ref, true);
          Navigator.of(context).pop();
          showSnackbar(context, "save_successfully".i18n,
              ref: ref, hasErrorLog: Analyser().errorList.isNotEmpty);
        },
      );
    }
    return PopupMenuButton(
      icon: const Icon(Icons.save),
      tooltip: 'save_option'.i18n,
      onSelected: (int selected) async {
        showDialog(
            context: context,
            builder: (BuildContext context) => ViewSaveDialog(selected != 0),
            barrierDismissible: false);
        switch (selected) {
          case 0:
            await savePlatform(ref, false);
            break;
          case 1:
            await savePlatform(ref, true);
            break;
        }
        showSnackbar(context, 'save_successfully'.i18n,
            ref: ref, hasErrorLog: Analyser().errorList.isNotEmpty);
        Navigator.of(context).pop();
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
