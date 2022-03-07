import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/view/view_variable_table.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ViewSource extends StatelessWidget {
  const ViewSource({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var widget = ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        var name = getPlatformFileSystem().getImageName(index);
        return Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: getPlatformFileSystem().getImage(name),
              ),
            ),
            Flexible(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(name),
                    TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText:
                            getPlatformFileSystem().getSource(name) ?? '출처를 여기에 적어주세요!',
                        alignLabelWithHint: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      itemCount: getPlatformFileSystem().getImageList().length,
    );

    if (ConstList.isSmallDisplay(context)) {
      return WillPopScope(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(ConstList.appBarSize),
            child: AppBar(),
          ),
          drawer: const ViewVariable(),
          body: widget,
        ),
        onWillPop: () async {
          return false;
        },
      );
    } else {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(ConstList.appBarSize),
          child: AppBar(),
        ),
        body: Row(
          children: [
            const ViewVariable(),
            Expanded(
              child: widget,
            ),
          ],
        ),
      );
    }
  }
}
