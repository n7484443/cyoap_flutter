import 'package:cyoap_flutter/view/view_draggable_nested_map.dart';
import 'package:cyoap_flutter/view/view_variable_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../viewModel/vm_platform.dart';

class ViewPlay extends ConsumerStatefulWidget {
  const ViewPlay({
    super.key,
  });

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

    return Scaffold(
      appBar: ConstList.isDistributed ? null : AppBar(),
      endDrawer: const Drawer(
        child: ViewPlayDrawer(),
      ),
      bottomNavigationBar: const VariableTiles(asBottom: true),
      body: const NestedScroll(),
    );
  }
}
