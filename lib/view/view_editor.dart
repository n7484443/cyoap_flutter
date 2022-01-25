import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zefyrka/zefyrka.dart';

import '../main.dart';
import '../viewModel/vm_editor.dart';

class ViewEditor extends StatelessWidget {
  const ViewEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (ConstList.actualPlatformType == platformType.mobile) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(ConstList.appBarSize),
          child: AppBar(),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
          ),
        ),
        body: const ViewEditorTyping(),
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
    } else {
      return Row(
        children: [
          Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
            ),
          ),
          VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          Expanded(
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(ConstList.appBarSize),
                child: AppBar(),
              ),
              body: const ViewEditorTyping(),
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
            ),
          ),
        ],
      );
    }
  }
}

class ViewEditorTyping extends StatefulWidget {
  const ViewEditorTyping({Key? key}) : super(key: key);

  @override
  _ViewEditorTypingState createState() => _ViewEditorTypingState();
}

class _ViewEditorTypingState extends State<ViewEditorTyping> {
  final TextEditingController _controller_title = TextEditingController();
  final ZefyrController _controller_body = ZefyrController();
  final FocusNode _focus_body = FocusNode();
  final VMEditor _vmEditor = Get.put(VMEditor());

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
    return Column(
      children: [
        Container(
          color: Colors.black12,
          child: TextField(
            controller: _controller_title,
            textAlign: TextAlign.center,
            decoration: InputDecoration(hintText: '제목'),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          children: [
            ZefyrToolbar.basic(
              controller: _controller_body,
              hideLink: true,
              hideQuote: true,
              hideListBullets: true,
              hideListNumbers: true,
              hideHorizontalRule: true,
              hideCodeBlock: true,
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(
                right: 5,
              ),
              child: OutlinedButton(
                child: Text('Edit Code'),
                onPressed: () {
                  Get.toNamed('/viewCodeEditor');
                },
              ),
            )
          ],
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
                child:
                    Positioned(top: 6, left: 5, child: Text('여기에 내용을 입력하세요')),
                visible: visblityOfContents,
              ),
            ],
          ),
        ),
      ],
    );
  }
}