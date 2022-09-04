import 'package:cyoap_flutter/view/view_draggable_nested_map.dart';
import 'package:cyoap_flutter/view/view_variable_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../viewModel/vm_platform.dart';
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
                  ref.watch(snackBarErrorProvider).map((e) => Text(e)).toList(),
            ),
        ),
        action: SnackBarAction(
          label: '클립보드로 복사',
          onPressed: () {
            Clipboard.setData(ClipboardData(
                text: ref.watch(snackBarErrorProvider).fold(
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
    if (ConstList.isDistributed) {
      doDistributeMode(ref);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (ConstList.isDistributed && !ref.watch(loadedProvider)) {
      return Scaffold(
        body: Center(
          child: Column(
            children: [
              const CircularProgressIndicator(),
              const Text('로딩중입니다. 잠시만 기다려주세요.'),
              Text(ref.watch(loadStringProvider)),
              Text(ref.watch(stopWatchProvider)),
            ],
          ),
        ),
      );
    }

    ref.listen(
      snackBarErrorProvider,
      (previous, List<String> next) {
        if (next.isNotEmpty) {
          _showSnackBar();
        }
      },
    );

    return Scaffold(
      appBar: ConstList.isDistributed ? null : AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      endDrawer: const Drawer(
        child: ViewPlayDrawer(),
      ),
      bottomNavigationBar: const VariableTiles(asBottom: true),
      body: const NestedScroll(),
    );
  }
}
