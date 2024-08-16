import 'dart:math';

import 'package:cyoap_flutter/util/color_helper.dart';
import 'package:cyoap_flutter/view/choice/view_choice_line.dart';
import 'package:cyoap_flutter/view/util/controller_adjustable_scroll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

import '../../main.dart';
import '../../model/platform_system.dart';
import '../../viewModel/choice/vm_choice.dart';
import '../../viewModel/edit/vm_design_setting.dart';

class ViewChoicePage extends ConsumerStatefulWidget {
  const ViewChoicePage({super.key});

  @override
  ConsumerState createState() => _ViewChoicePageState();
}

class _ViewChoicePageState extends ConsumerState<ViewChoicePage> {
  final AdjustableScrollController _scrollController =
      AdjustableScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void dragUpdate(double? pos) {
    if (pos == null) return;
    var maxHeight = MediaQuery.of(context).size.height;
    double topY = 0;
    double bottomY = maxHeight;

    var detectedRange = 100;
    var moveDistance = ConstList.isSmallDisplay(context) ? 1 : 1.5;
    var move = 0.0;
    if (pos < topY + detectedRange) {
      move = pos - (topY + detectedRange);
    } else if (pos > bottomY - detectedRange) {
      move = -pos + (bottomY + detectedRange);
    }
    move /= detectedRange;
    move *= moveDistance;
    _scrollController.jumpTo(max(_scrollController.offset + move, 0));
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(currentListviewTargetPosProvider, (before, after){
      const move = 128;
      if(after == null) return;
      bool checkInside(){
        var (relative, key) = ref.read(currentListviewTargetPosProvider.notifier).currentVisiblePosList.getRelativePosition(after);
        switch(relative){
          case RelativePosition.visible || RelativePosition.contain:
            if(key!.currentContext == null){
              ref.read(currentListviewTargetPosProvider.notifier).currentVisiblePosList.removeValue(key);
              return false;
            }
            Scrollable.ensureVisible(key.currentContext!);
            return true;
          case RelativePosition.up:
            if(_scrollController.offset - move <= 0) return true;
            _scrollController.jumpTo(_scrollController.offset - move);
            return false;
          case RelativePosition.down:
            if(_scrollController.offset + move >= _scrollController.position.maxScrollExtent) return true;
            _scrollController.jumpTo(_scrollController.offset + move);
            return false;
        }
      }
      void recursive(){
        if(checkInside()){
          ref.read(currentListviewTargetPosProvider.notifier).set(null);
          return;
        }
        WidgetsBinding.instance.addPostFrameCallback((duration){
          recursive();
        });
      }
      recursive();
    });
    var pos = ref.watch(currentChoicePageProvider);
    var designSetting = ref.watch(platformDesignSettingProvider);
    var childrenLength =
        ref.watch(choiceStatusProvider(pos)).getChildrenList().length;

    var length = getPlatformFileSystem.isEditable
        ? (childrenLength + 1) * 2
        : childrenLength * 2;
    var sliverList = List.generate(
      length,
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
    return DropMonitor(
      formats: Formats.standardFormats,
      onDropOver: (details) {
        dragUpdate(details.position.local.dy);
      },
      child: Container(
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
      ),
    );
  }
}
