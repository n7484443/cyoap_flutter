import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_core/design_setting.dart';
import 'package:cyoap_flutter/view/preset/view_choice_node_preset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../../model/image_db.dart';
import '../../model/platform.dart';
import '../../viewModel/preset/vm_choice_node_preset.dart';
import '../../viewModel/vm_choice_node.dart';
import '../../viewModel/vm_design_setting.dart';
import '../util/controller_adjustable_scroll.dart';
import '../view_choice_node.dart';

class ViewPresetTab extends ConsumerWidget {
  const ViewPresetTab({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var background = ref.watch(backgroundProvider);
    var backgroundAttribute = ref.watch(backgroundAttributeProvider);

    BoxFit backgroundBoxFit = BoxFit.contain;
    ImageRepeat backgroundRepeat = ImageRepeat.noRepeat;
    switch (backgroundAttribute) {
      case ImageAttribute.fill:
        backgroundBoxFit = BoxFit.cover;
        break;
      case ImageAttribute.fit:
        backgroundBoxFit = BoxFit.contain;
        break;
      case ImageAttribute.pattern:
        backgroundBoxFit = BoxFit.contain;
        backgroundRepeat = ImageRepeat.repeat;
        break;
      case ImageAttribute.stretch:
        backgroundBoxFit = BoxFit.fill;
        break;
    }

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
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: ref.watch(colorBackgroundProvider),
                image: background != null
                    ? DecorationImage(
                  image:
                  Image.memory(ImageDB().getImage(background)!).image,
                  fit: backgroundBoxFit,
                  repeat: backgroundRepeat,
                  filterQuality: FilterQuality.high,
                )
                    : null,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: IgnorePointer(
                      child: ViewChoiceNode(
                        Pos(data: [designSamplePosition]),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        ref
                            .read(presetTestSelectProvider.notifier)
                            .update((state) => !state);
                        var pos = Pos(data: [designSamplePosition]);
                        ref.invalidate(choiceNodeProvider(pos));
                      },
                      icon: const Icon(Icons.border_style)),
                ],
              ),
            ),
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
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: ref.watch(colorBackgroundProvider),
                  image: background != null
                      ? DecorationImage(
                    image: Image.memory(ImageDB().getImage(background)!)
                        .image,
                    fit: backgroundBoxFit,
                    repeat: backgroundRepeat,
                    filterQuality: FilterQuality.high,
                  )
                      : null,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: IgnorePointer(
                        child: ViewChoiceNode(
                          Pos(data: [designSamplePosition]),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          ref
                              .read(presetTestSelectProvider.notifier)
                              .update((state) => !state);
                          var pos = Pos(data: [designSamplePosition]);
                          ref.invalidate(choiceNodeProvider(pos));
                        },
                        icon: const Icon(Icons.border_style)),
                  ],
                ),
              ),
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