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
      title: const Center(child: Text('Back')),
      content: const Text('There is something unsaved. Do you want to save it?'),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        ElevatedButton(
          onPressed: () {
            backFunction(0);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (cancelFunction != null) {
              cancelFunction!();
            }
            backFunction(1);
          },
          child: const Text('No'),
        ),
        ElevatedButton(
          onPressed: () async {
            await saveFunction();
            backFunction(2);
          },
          child: const Text('Yes'),
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
      title: const Center(child: Text('!Warning!')),
      content: const Text('This is a complete deletion of the selected project and cannot be recovered. Are you sure you want to delete it?'),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        ElevatedButton(
          onPressed: () {
            if (cancelFunction != null) {
              cancelFunction!();
            }
            Navigator.pop(context, false);
          },
          child: const Text('No'),
        ),
        ElevatedButton(
          onPressed: () {
            if (acceptFunction != null) {
              acceptFunction!();
            }
            Navigator.pop(context, true);
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }
}
