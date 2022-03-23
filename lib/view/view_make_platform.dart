import 'package:cyoap_flutter/view/view_variable_table.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ViewMakePlatform extends StatelessWidget {
  final Widget body;
  const ViewMakePlatform(this.body, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (ConstList.isSmallDisplay(context)) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          drawer: const Drawer(
            child: ViewVariable(),
          ),
          body: body,
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
              child: body,
            ),
          ],
        ),
      ),
    );
  }
}
