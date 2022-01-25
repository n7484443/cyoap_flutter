import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zefyrka/zefyrka.dart';

import '../main.dart';

class ViewCodeEditor extends StatefulWidget {
  const ViewCodeEditor({Key? key}) : super(key: key);

  @override
  _ViewCodeEditorState createState() => _ViewCodeEditorState();
}

class _ViewCodeEditorState extends State<ViewCodeEditor> {
  final TextEditingController _controller_title = TextEditingController();
  final ZefyrController _controller_body = ZefyrController();
  final FocusNode _focus_body = FocusNode();

  bool visblityOfContents = true;

  @override
  void initState() {
    super.initState();

    _controller_body.document.changes.listen((event) {
      setState(() {
        visblityOfContents =
            _controller_body.plainTextEditingValue.text.isEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(ConstList.appBarSize),
        child: AppBar(),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller_title,
            textAlign: TextAlign.center,
            decoration: InputDecoration(hintText: '실행 조건'),
          ),
          TextField(
            controller: _controller_title,
            textAlign: TextAlign.center,
            decoration: InputDecoration(hintText: '숨김 조건(비어있을 시 항상 보임)'),
          ),
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(0.5),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: ZefyrEditor(
                      controller: _controller_body,
                      autofocus: true,
                      focusNode: _focus_body,
                      expands: true,
                    ),
                  ),
                ),
                Visibility(
                  child: Positioned(top: 6, left: 5, child: Text('선택시 스크립트')),
                  visible: visblityOfContents,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                Get.back();
              },
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.navigate_next),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
