import 'package:cyoap_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../viewModel/vm_start.dart';

class ViewStart extends StatelessWidget {
  const ViewStart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vmStart = Get.put(VMStartPlatform());
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('version : ${vmStart.version.value}'),
                    Obx(
                      () => Visibility(
                        visible: vmStart.needUpdate.value,
                        child: TextButton(
                          onPressed: () {
                            launchUrlString(
                                'https://github.com/n7484443/FlutterCyoap/releases');
                          },
                          child: const Text('새로운 버전이 나왔습니다!',
                              style: TextStyle(color: Colors.redAccent)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 9,
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.lightBlue),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      flex: 12,
                      child: Obx(
                        () => ListView.builder(
                          itemCount: vmStart.pathList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Obx(
                                () {
                                  var text = Text(vmStart.pathList[index]);
                                  return OutlinedButton(
                                    onPressed: () => vmStart.select = index,
                                    style: vmStart.select == index
                                        ? OutlinedButton.styleFrom(
                                            primary: Colors.white,
                                            backgroundColor: Colors.blue)
                                        : OutlinedButton.styleFrom(
                                            primary: Colors.black54),
                                    child: text,
                                  );
                                },
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  vmStart.removeFrequentPath(index);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            child: const Text('파일 추가'),
                            onPressed: () async {
                              if (await vmStart.addFile() == 0) {
                                vmStart.selected.value = 0;
                              }
                            },
                          ),
                          Visibility(
                            visible: !ConstList.isWeb(),
                            child: TextButton(
                              child: const Text('폴더 추가'),
                              onPressed: () async {
                                if (await vmStart.addDirectory() == 0) {
                                  vmStart.selected.value = 0;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const Expanded(
              flex: 2,
              child: SelectMode(),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectMode extends GetView<VMStartPlatform> {
  const SelectMode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              controller.openProject().then((value) {
                controller.editable = false;
                Get.toNamed('/viewPlay');
              });
            },
            child: const Center(
              child: Text(
                'Play',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 56,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              controller.openProject().then((value) {
                controller.editable = true;
                Get.toNamed('/viewMake');
              });
            },
            child: const Center(
              child: Text(
                'Make',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 56,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
