import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewModel/vm_make_platform.dart';

class ViewFontSource extends ConsumerWidget {
  const ViewFontSource({super.key});

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
