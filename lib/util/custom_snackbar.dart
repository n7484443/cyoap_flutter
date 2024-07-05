import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showSnackBar(BuildContext context, String text,
    {String? describe,
    bool autoHide = true,
    List<String>? errorLog,
    WidgetRef? ref}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(text),
          if (describe != null) Text(describe),
          if (errorLog != null && errorLog.isNotEmpty)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: errorLog.map((e) => Text(e)).toList(),
            ),
        ],
      ),
      duration: autoHide ? const Duration(seconds: 2) : const Duration(days: 1),
      showCloseIcon: !autoHide,
    ),
  );
}
