import 'package:cyoap_flutter/view/view_design.dart';
import 'package:cyoap_flutter/view/view_editor.dart';
import 'package:cyoap_flutter/view/view_font_source.dart';
import 'package:cyoap_flutter/view/view_global_settings.dart';
import 'package:cyoap_flutter/view/view_image_editor.dart';
import 'package:cyoap_flutter/view/view_make.dart';
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
    const children = [
      ViewMake(),
      ViewEditor(),
      ViewGlobalSetting(),
      ViewSource(),
      ViewFontSource(),
      ViewImageEditor(),
      ViewDesignSetting(),
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
          body: IndexedStack(
            index: ref.watch(changeTabProvider),
            children: children,
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
              child: IndexedStack(
                index: ref.watch(changeTabProvider),
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
