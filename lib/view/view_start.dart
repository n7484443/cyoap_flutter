import 'package:cyoap_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewModel/vm_start.dart';

class ViewStart extends StatelessWidget {
  const ViewStart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vmStart = Get.put(VMStartPlatform());
    vmStart.initFrequentPath();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 9,
            child: GetBuilder<VMStartPlatform>(
              builder: (_) => Stack(
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
                          child: ListView.separated(
                            itemCount: _.pathList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: ElevatedButton(
                                  onPressed: () => _.selectFrequentPath(index),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) {
                                      return _.getColor(index);
                                    }),
                                  ),
                                  child: Text(
                                      _.pathList.reversed.elementAt(index)),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _.removeFrequentPath(index);
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
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                child: const Text('Add File'),
                                onPressed: () async {
                                  if (await _.openFile() == 0) {
                                    _.selected = 0;
                                  }
                                },
                              ),
                              Visibility(
                                child: TextButton(
                                  child: const Text('Add Path'),
                                  onPressed: () async {
                                    if (await _.openDirectory() == 0) {
                                      _.selected = 0;
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('version : ${ConstList.version}'),
                        Visibility(
                          child: const Text('새로운 버전이 나왔습니다!',
                              style: TextStyle(color: Colors.redAccent)),
                          visible: _.needUpdate,
                        ),
                      ],
                    ),
                    alignment: Alignment.topRight,
                  ),
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
                controller.setEditable(false);
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
                controller.setEditable(true);
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
