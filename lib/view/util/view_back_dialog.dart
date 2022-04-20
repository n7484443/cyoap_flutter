import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewBackDialog extends StatelessWidget {
  final void Function() saveFunction;
  final void Function() backFunction;
  final void Function()? cancelFunction;
  const ViewBackDialog(this.saveFunction, this.backFunction, {this.cancelFunction, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('뒤로가기'),
      content: const Text('저장되지 않은 내용이 있습니다. 저장하시겠습니까?'),
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: () {
            if(cancelFunction != null) {
              cancelFunction!();
            }
            Get.back();
            backFunction();
          },
          child: const Text('아니오'),
        ),
        ElevatedButton(
          onPressed: () {
            saveFunction();
            Get.back();
            backFunction();
          },
          child: const Text('예'),
        ),
      ],
    );
  }
}
