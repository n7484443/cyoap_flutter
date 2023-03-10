import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../main.dart';

class AdjustableScrollController extends ScrollController {
  AdjustableScrollController([int extraScrollSpeed = 20]) {
    if (ConstList.isDesktop()) {
      super.addListener(() {
        ScrollDirection scrollDirection = super.position.userScrollDirection;
        if (scrollDirection != ScrollDirection.idle) {
          double scrollEnd = super.offset +
              (scrollDirection == ScrollDirection.reverse
                  ? extraScrollSpeed
                  : -extraScrollSpeed);
          scrollEnd = min(super.position.maxScrollExtent,
              max(super.position.minScrollExtent, scrollEnd));
          jumpTo(scrollEnd);
        }
      });
    }
  }
}

class HorizontalScroll extends StatefulWidget {
  final int itemCount;
  final Widget? Function(BuildContext, int) itemBuilder;

  const HorizontalScroll(
      {required this.itemCount, required this.itemBuilder, super.key});

  @override
  State<HorizontalScroll> createState() => _HorizontalScrollState();
}

class _HorizontalScrollState extends State<HorizontalScroll> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        }),
        child: ListView.separated(
          padding: const EdgeInsets.all(8.0),
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemBuilder: widget.itemBuilder,
          itemCount: widget.itemCount,
          separatorBuilder: (BuildContext context, int index) {
            return const VerticalDivider();
          },
        ),
      ),
    );
  }
}
