import 'package:cyoap_flutter/view/view_draggable_nested_map.dart';
import 'package:cyoap_flutter/view/view_variable_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../viewModel/vm_platform.dart';

class ViewPlay extends ConsumerStatefulWidget {
  const ViewPlay({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ViewPlayState();
}

class _ViewPlayState extends ConsumerState<ViewPlay> {
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

    var appbar = ConstList.isDistributed
        ? null
        : AppBar(
            leading: IconButton(
              tooltip: '뒤로가기',
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          );
    if (ConstList.isSmallDisplay(context)) {
      return Scaffold(
        appBar: appbar,
        drawer: const Drawer(
          child: ViewVariable(),
        ),
        body: const NestedMap(),
      );
    } else {
      return Scaffold(
        body: Row(
          children: [
            const LimitedBox(
              maxWidth: 250,
              child: ViewVariable(),
            ),
            Flexible(
              child: Scaffold(
                appBar: appbar,
                body: const NestedMap(),
              ),
            ),
          ],
        ),
      );
    }
  }
}
