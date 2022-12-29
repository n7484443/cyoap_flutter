import 'package:cyoap_flutter/view/preset/view_choice_node_preset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../util/controller_adjustable_scroll.dart';

class ViewPresetTab extends ConsumerWidget {
  const ViewPresetTab({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ConstList.isSmallDisplay(context)) {
      return CustomScrollView(
        controller: AdjustableScrollController(),
        slivers: [
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            delegate: SliverChildListDelegate([
              const ListTile(
                title: Text('선택지'),
                selected: true,
              ),
              const PresetList(),
            ]),
          ),
          const SliverToBoxAdapter(
            child: ChoiceNodeSample(),
          ),
          const SliverToBoxAdapter(
            child: ViewNodeOptionEditor(),
          )
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(children: [
            Expanded(
              child: ListView(
                controller: AdjustableScrollController(),
                children: [
                  const ListTile(
                    title: Text('선택지'),
                    selected: true,
                  ),
                ],
              ),
            ),
            const Expanded(
              child: ChoiceNodeSample(),
            )
          ]),
        ),
        const Expanded(
          child: PresetList(),
        ),
        const Expanded(flex: 4, child: ViewNodeOptionEditor()),
      ],
    );
  }
}