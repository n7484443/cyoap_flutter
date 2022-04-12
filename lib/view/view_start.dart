import 'package:cyoap_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../viewModel/vm_start.dart';

class ViewStart extends StatelessWidget {
  const ViewStart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vmStart = Get.put(VMStartPlatform());
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 9,
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.lightBlue),
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 12,
                        child: Obx(() => ListView.separated(
                            itemCount: vmStart.pathList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: ElevatedButton(
                                  onPressed: () => vmStart.select = index,
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) {
                                      return vmStart.getColor(index);
                                    }),
                                  ),
                                  child: Text(
                                      vmStart.pathList[vmStart.pathList.length - 1 - index]),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    vmStart.removeFrequentPath(index);
                                  },
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const Divider();
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
                              child: TextButton(
                                child: const Text('폴더 추가'),
                                onPressed: () async {
                                  if (await vmStart.addDirectory() == 0) {
                                    vmStart.selected.value = 0;
                                  }
                                },
                              ),
                              visible: !ConstList.isOnlyFileAccept(),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Align(
                    child: Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                        Text('version : ${vmStart.version.value}'),
                        Obx(
                          () => Visibility(
                            child: const Text('새로운 버전이 나왔습니다!',
                                style: TextStyle(color: Colors.redAccent)),
                            visible: vmStart.needUpdate.value,
                          ),
                        ),
                      ],
                      ),
                    ),
                    alignment: Alignment.topRight,
                  ),
                ],
              ),
          ),
          const Expanded(
            flex: 2,
            child: SelectMode(),
          ),
        ],
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
              controller.setDirectory().then((value) {
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
              controller.setDirectory().then((value) {
                controller.editable = false;
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
