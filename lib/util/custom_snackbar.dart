import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewModel/vm_snackbar.dart';

void showSnackbar(BuildContext context, String text,
    {String? describe,
    bool autoHide = true,
    bool hasErrorLog = false,
    WidgetRef? ref}) {
  autoHide = autoHide && !hasErrorLog;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(text),
          if (describe != null) Text(describe),
          if (!autoHide)
            Card(
              child: IconButton(
                onPressed: () =>
                    ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                icon: const Icon(Icons.close),
              ),
            ),
          if (hasErrorLog)
            Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  ref!.read(snackBarErrorProvider).map((e) => Text(e)).toList(),
            ),
        ],
      ),
      duration: autoHide ? const Duration(seconds: 2) : const Duration(days: 1),
    ),
  );
}
