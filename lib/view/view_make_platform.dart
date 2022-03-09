import 'package:cyoap_flutter/view/view_code_editor.dart';
import 'package:cyoap_flutter/view/view_editor.dart';
import 'package:cyoap_flutter/view/view_global_settings.dart';
import 'package:cyoap_flutter/view/view_make.dart';
import 'package:cyoap_flutter/view/view_source.dart';
import 'package:cyoap_flutter/view/view_variable_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';

class ViewMakePlatform extends StatelessWidget {
  const ViewMakePlatform({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var navigator = Navigator(
      key: Get.nestedKey(1),
      initialRoute: '/viewMake',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/viewMake':
            return GetPageRoute(
              page: () => const ViewMake(),
            );
          case '/viewEditor':
            return GetPageRoute(
              page: () => const ViewEditor(),
            );
          case '/viewCodeEditor':
            return GetPageRoute(
              page: () => const ViewCodeEditor(),
            );
          case '/viewGlobalSetting':
            return GetPageRoute(
              page: () => const ViewGlobalSetting(),
            );
          case '/viewSource':
            return GetPageRoute(
              page: () => const ViewSource(),
            );
          default:
            return null;
        }
      },
    );
    if (ConstList.isSmallDisplay(context)) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          drawer: const Drawer(
            child: ViewVariable(),
          ),
          body: navigator,
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
              child: navigator,
            ),
          ],
        ),
      ),
    );
  }
}