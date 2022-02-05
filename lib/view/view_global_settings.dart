import 'package:cyoap_flutter/util/tuple.dart';
import 'package:cyoap_flutter/viewModel/vm_global_setting.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../main.dart';

class ViewGlobalSetting extends StatelessWidget {
  const ViewGlobalSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vmGlobalSetting = Get.put(VMGlobalSetting());
    var appbarWidget = PreferredSize(
      preferredSize: Size.fromHeight(ConstList.appBarSize),
      child: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if(vmGlobalSetting.isChanged){
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('뒤로가기'),
                  content: const Text('저장되지 않은 내용이 있습니다. 저장하시겠습니까?'),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        vmGlobalSetting.isChanged = false;
                        Get.back();
                        Get.back();
                      },
                      child: const Text('아니오'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        vmGlobalSetting.save(ConstList.isFileSystem());
                        Get.back();
                        Get.back();
                      },
                      child: const Text('예'),
                    ),
                  ],
                ),
              );
            }else{
              Get.back();
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              vmGlobalSetting.save(false);
            },
          )
        ],
      ),
    );


    return Scaffold(
      appBar: appbarWidget,
    );
  }
}
