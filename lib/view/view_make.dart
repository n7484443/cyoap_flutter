import 'package:cyoap_flutter/viewModel/vm_platform.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';

class ViewMake extends StatelessWidget {
  const ViewMake({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vmPlatform = Get.put(VMPlatform());
    vmPlatform.updateWidgetList();
    return GetBuilder<VMPlatform>(
      builder: (_) => Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(ConstList.appBarSize),
          child: AppBar(
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 15),
                child: const Icon(Icons.menu),
              )
            ],
          ),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                List<Widget>.generate(vmPlatform.widgetList.length, (int i) {
                  return Wrap(
                    alignment: WrapAlignment.center,
                    children: List<Widget>.generate(
                      vmPlatform.widgetList[i].length,
                      (int j) {
                        return vmPlatform.widgetList[i][j];
                      },
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
