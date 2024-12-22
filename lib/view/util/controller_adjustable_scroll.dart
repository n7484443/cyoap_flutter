import 'dart:ui';

import 'package:flutter/material.dart';

class HorizontalScroll extends StatefulWidget {
  final int itemCount;
  final Widget? Function(BuildContext context, int index) itemBuilder;

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
            return const Padding(padding: EdgeInsets.all(2.0));
          },
        ),
      ),
    );
  }
}

class HorizontalScrollSingleChild extends StatefulWidget {
  final Widget child;
  const HorizontalScrollSingleChild({required this.child, super.key});

  @override
  State<HorizontalScrollSingleChild> createState() =>
      _HorizontalScrollSingleChildState();
}

class _HorizontalScrollSingleChildState
    extends State<HorizontalScrollSingleChild> {
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
      radius: const Radius.circular(20.0),
      thickness: 12.0,
      thumbVisibility: true,
      trackVisibility: true,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        }),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          child: widget.child,
        ),
      ),
    );
  }
}
