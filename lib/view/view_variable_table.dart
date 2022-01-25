import 'package:flutter/material.dart';

class ViewVariable extends StatelessWidget {
  const ViewVariable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const ExpansionTile(
            title: Text('변수'),
            children: [
              ListTile(title: Text('세부')),
              ListTile(title: Text('세부2')),
            ],
          ),
          const ExpansionTile(
            title: Text('노드'),
            children: [
              ListTile(title: Text('세부')),
              ListTile(title: Text('세부2')),
            ],
          ),
        ],
      ),
    );
  }
}
