import 'dart:math';

import 'package:cyoap_core/preset/layout.dart' hide Text;
import 'package:cyoap_core/preset/layout.dart' as lo;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class NodeLayoutWidget extends MultiChildRenderObjectWidget {
  final List<NodeLayoutElement> childrenLayout;

  const NodeLayoutWidget({
    required this.childrenLayout,
    required super.children,
    super.key,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderNodeLayout(childrenLayout: childrenLayout);
  }

  @override
  void updateRenderObject(BuildContext context, RenderNodeLayout renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject.childrenLayout = childrenLayout;
  }
}

class RenderNodeLayout extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData> {
  late List<NodeLayoutElement> _childrenLayout;

  List<NodeLayoutElement> get childrenLayout => _childrenLayout;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! MultiChildLayoutParentData) {
      child.parentData = MultiChildLayoutParentData();
    }
  }

  set childrenLayout(List<NodeLayoutElement> value) {
    if (_childrenLayout.length == value.length) {
      for (int i = 0; i < _childrenLayout.length; i++) {
        if (_childrenLayout[i] != value[i]) {
          _childrenLayout = value;
          markNeedsLayout();
          return;
        }
      }
    } else {
      _childrenLayout = value;
      markNeedsPaint();
    }
  }

  RenderNodeLayout({
    required List<NodeLayoutElement> childrenLayout,
  }) {
    _childrenLayout = childrenLayout;
  }

  List<(int, lo.Content)> get intrinsicAdaptiveLayoutList {
    return _childrenLayout.indexed.whereType<(int, lo.Content)>().toList();
  }

  @override
  void performLayout() {
    var parentWidth = constraints.maxWidth;
    var parentHeight = constraints.maxHeight;
    var intrinsicAdaptiveLayoutList = this.intrinsicAdaptiveLayoutList;
    var intrinsicWidthList = intrinsicAdaptiveLayoutList
        .map((e) => e.$2.getIntrinsicWidth(parentWidth))
        .toList();
    var intrinsicIndexList =
    intrinsicAdaptiveLayoutList.map((e) => e.$1).toList();
    var intrinsicHeightList = <double>[];

    RenderBox? child = firstChild;
    int intrinsicIndex = 0;
    //first pass, get min height
    for (int index = 0; child != null; index++) {
      final MultiChildLayoutParentData childParentData =
      child.parentData! as MultiChildLayoutParentData;
      assert(child.parentData == childParentData);
      if (intrinsicIndex < intrinsicIndexList.length &&
          index == intrinsicIndexList[intrinsicIndex]) {
        intrinsicHeightList.add(
            child.getMinIntrinsicHeight(intrinsicWidthList[intrinsicIndex]));
        intrinsicIndex++;
      } else {
        intrinsicHeightList
            .add(_childrenLayout[index].getIntrinsicHeight(parentHeight));
      }
      child = childAfter(child);
    }

    size = constraints
        .constrain(Size(constraints.maxWidth, intrinsicHeightList.reduce(max)));

    child = firstChild;
    //second pass, set child's offset/constrain
    for (int index = 0; child != null; index++) {
      final MultiChildLayoutParentData childParentData =
      child.parentData! as MultiChildLayoutParentData;

      var element = _childrenLayout[index];
      var left = element.responsiveBox.left?.value(size.width);
      var right = element.responsiveBox.right?.value(size.width);
      var top = element.responsiveBox.top?.value(size.height);
      var bottom = element.responsiveBox.bottom?.value(size.height);
      var width = element.responsiveBox.width?.value(size.width);
      var height = element.responsiveBox.height?.value(size.height);

      assert(left != null || right != null);
      assert(top != null || bottom != null);
      if (width != null) {
        if (left == null) {
          left = right! - width;
        } else {
          right = left + width;
        }
      } else {
        width = size.width - left! - right!;
      }
      if (height != null) {
        if (top == null) {
          top = bottom! - height;
        } else {
          bottom = top + height;
        }
      } else {
        height = size.height - top! - bottom!;
      }
      childParentData.offset = Offset(left, top);
      child.layout(BoxConstraints(
        minWidth: width,
        maxWidth: width,
        minHeight: height,
        maxHeight: height,
      ));
      child = childAfter(child);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    //list 순서 대로 위치시켜서 그리기
    RenderBox? child = firstChild;

    while (child != null) {
      final MultiChildLayoutParentData childParentData =
      child.parentData! as MultiChildLayoutParentData;
      assert(child.parentData == childParentData);
      context.paintChild(child, childParentData.offset + offset);

      child = childAfter(child);
    }
  }
}