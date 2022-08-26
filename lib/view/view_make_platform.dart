import 'package:cyoap_flutter/view/view_variable_table.dart';
import 'package:cyoap_flutter/viewModel/vm_make_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';

class ViewMakePlatform extends ConsumerWidget {
  const ViewMakePlatform({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ConstList.isSmallDisplay(context)) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          drawer: const Drawer(
            child: ViewVariable(),
          ),
          body: ref.watch(tabWidgetProvider),
        ),
      );
    }
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Row(
          children: [
            const LimitedBox(
              maxWidth: 250,
              child: ViewVariable(),
            ),
            Flexible(
              child: ref.watch(tabWidgetProvider),
            ),
          ],
        ),
      ),
    );
  }
}
