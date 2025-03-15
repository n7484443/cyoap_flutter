import 'package:cyoap_core/preset/node_preset.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_drawing/path_drawing.dart';

class OutlineOverlay extends SingleChildRenderObjectWidget {
  final EdgeInsets edgeInsets;
  final BorderRadius borderRadius;
  final OutlineType outlineType;
  final Color color;
  final double strokeWidth;

  const OutlineOverlay({
    required this.edgeInsets,
    required this.borderRadius,
    required this.outlineType,
    required this.color,
    required this.strokeWidth,
    super.child,
    super.key,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderOutlineOverlay(outlineType: outlineType, edgeInsets: edgeInsets, borderRadius: borderRadius, color: color, strokeWidth: strokeWidth);
  }

  @override
  void updateRenderObject(BuildContext context, RenderOutlineOverlay renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject.edgeInsets = edgeInsets;
    renderObject.borderRadius = borderRadius;
    renderObject.outlineType = outlineType;
    renderObject.color = color;
    renderObject.strokeWidth = strokeWidth;
  }
}

class RenderOutlineOverlay extends RenderProxyBox {
  late EdgeInsets _edgeInsets;
  late BorderRadius _borderRadius;
  late OutlineType _outlineType;
  late Color _color;
  late double _strokeWidth;

  RenderOutlineOverlay({
    required EdgeInsets edgeInsets,
    required BorderRadius borderRadius,
    required OutlineType outlineType,
    required Color color,
    required double strokeWidth,
  }) {
    _edgeInsets = edgeInsets;
    _borderRadius = borderRadius;
    _outlineType = outlineType;
    _color = color;
    _strokeWidth = strokeWidth;
  }

  EdgeInsets get edgeInsets => _edgeInsets;

  set edgeInsets(EdgeInsets value) {
    if (_edgeInsets == value) {
      return;
    }
    _edgeInsets = value;
    markNeedsPaint();
  }

  BorderRadius get borderRadius => _borderRadius;

  set borderRadius(BorderRadius value) {
    if (_borderRadius == value) {
      return;
    }
    _borderRadius = value;
    markNeedsPaint();
  }

  OutlineType get outlineType => _outlineType;

  set outlineType(OutlineType value) {
    if (_outlineType == value) {
      return;
    }
    _outlineType = value;
    markNeedsPaint();
  }

  Color get color => _color;

  set color(Color value) {
    if (_color == value) {
      return;
    }
    _color = value;
    markNeedsPaint();
  }

  double get strokeWidth => _strokeWidth;

  set strokeWidth(double value) {
    if (_strokeWidth == value) {
      return;
    }
    _strokeWidth = value;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    final canvas = context.canvas;
    final size = child!.size;
    var left = offset.dx + _edgeInsets.left;
    var top = offset.dy + _edgeInsets.top;
    var right = offset.dx + size.width - _edgeInsets.right;
    var bottom = offset.dy + size.height - _edgeInsets.bottom;
    if (strokeWidth <= 0) {
      return;
    }
    Path path = Path()
      ..addRRect(RRect.fromRectAndCorners(Rect.fromLTRB(left, top, right, bottom),
          bottomLeft: _borderRadius.bottomLeft, bottomRight: _borderRadius.bottomRight, topLeft: _borderRadius.topLeft, topRight: _borderRadius.topRight));
    switch (_outlineType) {
      case OutlineType.none:
        return;
      case OutlineType.solid:
        break;
      case OutlineType.dotted:
        path = dashPath(path, dashArray: CircularIntervalList([strokeWidth, strokeWidth]));
        break;
      case OutlineType.dashed:
        path = dashPath(path, dashArray: CircularIntervalList([strokeWidth * 2, strokeWidth]));
        break;
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );
  }
}
