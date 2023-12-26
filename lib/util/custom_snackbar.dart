import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String text,
    {String? describe, bool autoHide = true}) {
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
            )
        ],
      ),
      duration: autoHide ? const Duration(seconds: 2) : const Duration(days: 1),
    ),
  );
}
