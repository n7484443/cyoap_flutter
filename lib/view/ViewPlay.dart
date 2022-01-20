import 'package:flutter/material.dart';

class ViewPlay extends StatelessWidget {
  const ViewPlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white60,
      child: TextButton(
        onPressed: () {Navigator.pop(context);},
        child: const Text('ㄱㄴㄷ'),
      ),
    );
  }
}
