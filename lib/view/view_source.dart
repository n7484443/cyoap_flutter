import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../model/image_db.dart';
import '../viewModel/vm_source.dart';

class ViewSource extends StatelessWidget {
  const ViewSource({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(VMSource());
    var widget = ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        var name = ImageDB().getImageName(index);
        return Card(
          elevation: ConstList.elevation,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: getPlatformFileSystem.getImage(name),
                ),
              ),
              Flexible(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(name),
                      TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: getPlatformFileSystem.getSource(name) ??
                              '출처를 여기에 적어주세요!',
                          alignLabelWithHint: true,
                        ),
                        controller: controller.getTextEditor(name),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      itemCount: ImageDB().imageList.length,
    );

    return WillPopScope(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(ConstList.appBarSize),
          child: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Get.back(id: 1);
              },
            ),
          ),
        ),
        body: widget,
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}
