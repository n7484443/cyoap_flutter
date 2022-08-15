import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewModel/vm_make_platform.dart';

class ViewFontSource extends ConsumerWidget {
  const ViewFontSource({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(changeTabProvider.notifier).back(context);
          },
        ),
      ),
      body: ListView(
        controller: ScrollController(),
        children: [
          const ListTile(
            title: Text('메이플스토리 서체 및 넥슨 폰트'),
            subtitle: Text("""
            본 서체의 지적 재산권을 포함한 모든 권리는 ㈜넥슨코리아에 있습니다.
            본 서체는 개인 및 기업 사용자를 포함한 모든 사용자에게 무료로 제공되며 자유롭게 사용 및 배포하실 수 있습니다.
            단, 임의로 수정, 편집 등을 할 수 없으며 배포되는 형태 그대로 사용해야 합니다.글꼴 자체를 유료로 판매하는 것은 금지됩니다.
            """),
          ),
          const ListTile(
            title: Text('neo 둥근모'),
            subtitle: Text("""
            Copyright © 2017-2022, Eunbin Jeong (Dalgona.) <project-neodgm@dalgona.dev> with reserved font name "Neo둥근모" and "NeoDunggeunmo".
            """),
          )
        ],
      ),
    );
  }
}
