import 'package:flutter/material.dart';

class ViewBackDialog extends StatelessWidget {
  final Future<void> Function() saveFunction;
  final void Function(int) backFunction;
  final void Function()? cancelFunction;
  const ViewBackDialog(this.saveFunction, this.backFunction,
      {this.cancelFunction, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text('뒤로가기')),
      content: const Text('저장되지 않은 내용이 있습니다. 저장하시겠습니까?'),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        ElevatedButton(
          onPressed: () {
            backFunction(0);
          },
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: () {
            if (cancelFunction != null) {
              cancelFunction!();
            }
            backFunction(1);
          },
          child: const Text('아니오'),
        ),
        ElevatedButton(
          onPressed: () async {
            await saveFunction();
            backFunction(2);
          },
          child: const Text('예'),
        ),
      ],
    );
  }
}

class ViewWarningDialog extends StatelessWidget {
  final void Function()? cancelFunction;
  final void Function()? acceptFunction;
  const ViewWarningDialog(
      {this.acceptFunction, this.cancelFunction, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text('!경고!')),
      content: const Text('이것은 선택된 프로젝트를 완전히 삭제하는 것이며, 복구할 수 없습니다. 삭제하시겠습니까?'),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        ElevatedButton(
          onPressed: () {
            if (cancelFunction != null) {
              cancelFunction!();
            }
            Navigator.pop(context, false);
          },
          child: const Text('아니오'),
        ),
        ElevatedButton(
          onPressed: () {
            if (acceptFunction != null) {
              acceptFunction!();
            }
            Navigator.pop(context, true);
          },
          child: const Text('예'),
        ),
      ],
    );
  }
}
