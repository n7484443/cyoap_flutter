import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/view/choice/view_choice_page.dart';
import 'package:cyoap_flutter/view/view_selected_grid.dart';
import 'package:cyoap_flutter/view/view_variable_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../util/custom_snackbar.dart';
import '../viewModel/vm_play.dart';
import '../viewModel/vm_selected_grid.dart';
import '../viewModel/vm_snackbar.dart';

class ViewPlay extends ConsumerStatefulWidget {
  const ViewPlay({
    super.key,
  });

  @override
  ConsumerState createState() => _ViewPlayState();
}

class _ViewPlayState extends ConsumerState<ViewPlay> {
  void _showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                ref.read(snackBarErrorProvider).map((e) => Text(e)).toList(),
          ),
        ),
        action: SnackBarAction(
          label: 'copy_clipboard'.i18n,
          onPressed: () {
            Clipboard.setData(ClipboardData(
                text: ref.read(snackBarErrorProvider).fold(
                      "",
                      (previousValue, element) => "$previousValue \n $element",
                    )));
            ref.read(snackBarErrorProvider.notifier).clear();
          },
        ),
        duration: const Duration(days: 365),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      snackBarErrorProvider,
      (previous, List<String> next) {
        if (next.isNotEmpty) {
          _showSnackBar();
        }
      },
    );
    if (ConstList.isSmallDisplay(context)) {
      return PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pushReplacementNamed("/"),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () async {
                      var status = await ref
                          .read(playDataProvider.notifier)
                          .savePlayData();
                      showSnackBar(context, status);
                    },
                    icon: const Icon(Icons.save)),
                IconButton(
                    onPressed: () async {
                      var status = await ref
                          .read(playDataProvider.notifier)
                          .loadPlayData();
                      if (status != null) {
                        showSnackBar(context, status);
                      }
                    },
                    icon: const Icon(Icons.file_upload_outlined)),
                FilledButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
                  onPressed: () {
                    if (ref
                        .watch(selectedchoiceNodeStatusProvider)
                        .isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) => const ViewSelectedGrid(),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('summary_error'.i18n),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                  child: Text("summary".i18n),
                ),
              ],
            ),
          ),
          endDrawer: const Drawer(
            child: ViewPlayDrawer(),
          ),
          bottomNavigationBar: const BottomDisplayedVariableWidget(),
          body: const ViewChoicePage(),
        ),
      );
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.list),
            onPressed: () =>
                ref.read(isOpenSideProvider.notifier).update((state) => !state),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pushReplacementNamed("/"),
            ),
          ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () async {
                    var status = await ref
                        .read(playDataProvider.notifier)
                        .savePlayData();
                    showSnackBar(context, status);
                  },
                  icon: const Icon(Icons.save)),
              IconButton(
                  onPressed: () async {
                    var status = await ref
                        .read(playDataProvider.notifier)
                        .loadPlayData();
                    if (status != null) {
                      showSnackBar(context, status);
                    }
                  },
                  icon: const Icon(Icons.file_upload_outlined)),
              const Spacer(),
              FilledButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                onPressed: () {
                  if (ref.watch(selectedchoiceNodeStatusProvider).isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) => const ViewSelectedGrid(),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('summary_error'.i18n),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                },
                child: Text("summary".i18n),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomDisplayedVariableWidget(),
        body: Row(
          children: [
            AnimatedSize(
              duration: ConstList.durationAnimation,
              child: SizedBox(
                width: ref.watch(isOpenSideProvider) ? 250 : 0,
                child: const ViewPlayDrawer(),
              ),
            ),
            const Expanded(child: ViewChoicePage()),
          ],
        ),
      ),
    );
  }
}
