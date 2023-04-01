import 'package:cyoap_flutter/view/view_design.dart';
import 'package:cyoap_flutter/view/view_editor.dart';
import 'package:cyoap_flutter/view/view_image_editor.dart';
import 'package:cyoap_flutter/view/view_make.dart';
import 'package:cyoap_flutter/view/view_project_settings.dart';
import 'package:cyoap_flutter/view/view_source.dart';
import 'package:cyoap_flutter/view/view_variable_table.dart';
import 'package:cyoap_flutter/viewModel/vm_make_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';

class ViewMakePlatform extends ConsumerStatefulWidget {
  const ViewMakePlatform({
    super.key,
  });

  @override
  ConsumerState createState() => _ViewMakePlatformState();
}

class _ViewMakePlatformState extends ConsumerState<ViewMakePlatform> {
  @override
  Widget build(BuildContext context) {
    const defaultMap = ViewMake();
    var childrenFunction = [
      () => const ViewEditor(),
      () => const ViewProjectSetting(),
      () => const ViewSource(),
      () => const ViewImageEditor(),
      () => const ViewDesignSetting(),
    ];
    if (ConstList.isSmallDisplay(context)) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          drawer: const Drawer(
            child: ViewEditDrawer(),
          ),
          body: ref.watch(changeTabProvider) == 0
              ? defaultMap
              : Stack(
                  children: [
                    defaultMap,
                    childrenFunction[ref.watch(changeTabProvider) - 1]()
                  ],
                ),
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
              child: ViewEditDrawer(),
            ),
            Flexible(
              child: ref.watch(changeTabProvider) == 0
                  ? defaultMap
                  : Stack(
                      children: [
                        defaultMap,
                        childrenFunction[ref.watch(changeTabProvider) - 1]()
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
