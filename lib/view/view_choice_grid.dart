import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewModel/vm_platform.dart';

class ChoiceSetGrid extends StatelessWidget {
  const ChoiceSetGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vmPlatform = Get.put(VMPlatform());
    vmPlatform.updateWidgetList();
    return GetBuilder<VMPlatform>(
      builder: (_) => ListView.builder(
        shrinkWrap: true,
        itemCount: vmPlatform.widgetList.length,
        itemBuilder: (BuildContext context, int i) {
          return Column(
            children: [
              Divider(),
              Padding(
                padding: const EdgeInsets.only(
                  top: 12,
                  bottom: 12,
                ),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: List<Widget>.generate(
                    vmPlatform.widgetList[i].length,
                        (int j) {
                      return vmPlatform.widgetList[i][j];
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}