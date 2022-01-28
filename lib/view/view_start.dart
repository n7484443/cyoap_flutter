import 'package:cyoap_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../viewmodel/vm_startplatform.dart';

class ViewStart extends StatelessWidget {
  const ViewStart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vmStart = Get.put(VMStartPlatform());
    vmStart.initFrequentPath();
    return GetBuilder<VMStartPlatform>(
      builder: (_) => Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 9,
              child: Column(
                children: [
                  Expanded(
                    flex: 18,
                    child: ListView.separated(
                      itemCount: _.pathList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _.selectFrequentPath(index);
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                                    return _.getColor(index);
                                  }),
                                ),
                                child: Text(
                                    _.pathList.reversed.elementAt(index)),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _.removeFrequentPath(index);
                                },
                              )
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                      },
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      child: Text(ConstList.actualPlatformType == platformType.web ? 'Add File' : 'Add Path' ),
                      onPressed: () async {
                        if (await _.openDirectory() == 0) {
                          _.selected = 0;
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            const Expanded(
              flex: 4,
              child: SelectMode(),
            )
          ],
        ),
      ),
    );
  }
}

class SelectMode extends StatelessWidget {
  const SelectMode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              Get.find<VMStartPlatform>().setDirectory().then((value){
                Get.find<VMStartPlatform>().setEditable(false);
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
              Get.find<VMStartPlatform>().setDirectory().then((value) {
                Get.find<VMStartPlatform>().setEditable(true);
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
