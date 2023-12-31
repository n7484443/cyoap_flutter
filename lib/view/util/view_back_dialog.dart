import 'package:cyoap_flutter/i18n.dart';
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
      title: Center(child: Text('back'.i18n)),
      content: Text('unsaved'.i18n),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        ElevatedButton(
          onPressed: () {
            backFunction(0);
          },
          child: Text('cancel'.i18n),
        ),
        ElevatedButton(
          onPressed: () {
            if (cancelFunction != null) {
              cancelFunction!();
            }
            backFunction(1);
          },
          child: Text('no'.i18n),
        ),
        ElevatedButton(
          onPressed: () async {
            await saveFunction();
            backFunction(2);
          },
          child: Text('yes'.i18n),
        ),
      ],
    );
  }
}

class ViewWarningDialog extends StatelessWidget {
  final void Function()? cancelFunction;
  final void Function()? acceptFunction;
  final String content;
  const ViewWarningDialog(
      {this.acceptFunction,
      this.cancelFunction,
      required this.content,
      super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning),
            Text('warning'.i18n),
            const Icon(Icons.warning),
          ],
        ),
      ),
      content: Text(content),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        ElevatedButton(
          onPressed: () {
            if (cancelFunction != null) {
              cancelFunction!();
            }
            Navigator.pop(context, false);
          },
          child: Text('no'.i18n),
        ),
        ElevatedButton(
          onPressed: () {
            if (acceptFunction != null) {
              acceptFunction!();
            }
            Navigator.pop(context, true);
          },
          child: Text('yes'.i18n),
        ),
      ],
    );
  }
}
