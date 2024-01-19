import 'dart:math';

import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/util/color_helper.dart';
import 'package:cyoap_flutter/view/util/controller_adjustable_scroll.dart';
import 'package:cyoap_flutter/view/choice/view_choice_line.dart';
import 'package:cyoap_flutter/view/view_selected_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../../model/platform_system.dart';
import '../../viewModel/choice/vm_choice.dart';
import '../../viewModel/vm_design_setting.dart';
import '../../viewModel/vm_draggable_nested_map.dart';
import '../../viewModel/vm_selected_grid.dart';

class ViewChoicePage extends ConsumerStatefulWidget {
  const ViewChoicePage({super.key});

  @override
  ConsumerState createState() => _ViewChoicePageState();
}

class _ViewChoicePageState extends ConsumerState<ViewChoicePage> {
  final AdjustableScrollController _scrollController =
      AdjustableScrollController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void dragUpdate(double? pos) {
    if (pos == null) return;
    var maxHeight = MediaQuery.of(context).size.height;
    double topY = 0;
    double bottomY = topY + maxHeight;

    var detectedRange = maxHeight * 0.06;
    var moveDistance = ConstList.isSmallDisplay(context) ? 0.8 : 1;
    if (pos < topY + detectedRange) {
      _scrollController.jumpTo(max(_scrollController.offset - moveDistance, 0));
    }
    if (pos > bottomY - detectedRange) {
      _scrollController.jumpTo(_scrollController.offset + moveDistance);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<double?>(
        dragPositionProvider, (previous, next) => dragUpdate(next));
    var pos = ref.watch(currentChoicePageProvider);
    var designSetting = ref.watch(platformDesignSettingProvider);
    var childrenLength =
        ref.watch(choiceStatusProvider(pos)).getChildrenList().length;

    var sliverList = List.generate(
      (childrenLength + 1) * 2,
      (index) {
        var realIndex = index ~/ 2;
        var currentPos = pos.addLast(realIndex);
        var isOutOfLength = realIndex >= childrenLength;
        if (index.isEven) {
          return SliverToBoxAdapter(
            child: ViewChoiceLineHeader(
              pos: currentPos,
              isOutOfLength: isOutOfLength,
            ),
          );
        }
        return ViewChoiceLine(
          pos: currentPos,
          isOutOfLength: isOutOfLength,
        );
      },
    );
    if (!isEditable) {
      sliverList.add(SliverToBoxAdapter(
        child: TextButton(
          onPressed: () {
            if (ref.watch(selectedchoiceNodeStatusProvider).isNotEmpty) {
              showDialog(
                context: context,
                builder: (context) => const ViewSelectedGrid(),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('summary_error'.i18n),
                  duration: const Duration(seconds: 1),
                ),
              );
            }
          },
          child: Text("summary".i18n),
        ),
      ));
      sliverList.add(const SliverPadding(
        padding: EdgeInsets.all(50),
      ));
    }
    return Container(
      decoration: BoxDecoration(
        color: designSetting.backgroundColorOption.getColor(),
        gradient: designSetting.backgroundColorOption.getGradient(),
        image: ref.watch(platformDesignSettingImageDecorationProvider),
      ),
      child: Scrollbar(
        controller: _scrollController,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: sliverList,
        ),
      ),
    );
  }
}
