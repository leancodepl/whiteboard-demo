import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:whiteboard_demo/features/whiteboard_page/models/line.dart';
import 'package:whiteboard_demo/features/whiteboard_page/models/point.dart';

const aspectRatio = 9 / 16;

class WhiteboardView extends StatelessWidget {
  const WhiteboardView({
    Key key,
    @required this.lines,
    @required this.onGestureStart,
    @required this.onGestureUpdate,
    @required this.onGestureEnd,
  })  : assert(lines != null),
        super(key: key);

  final List<Line> lines;
  final ValueChanged<Point> onGestureStart;
  final void Function(Point point, Point previousPoint) onGestureUpdate;
  final VoidCallback onGestureEnd;

  Widget build(BuildContext context) => Material(
        elevation: 4,
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: LayoutBuilder(
            builder: (context, constraints) => GestureDetector(
              onPanDown: (details) => onGestureStart?.call(
                  _getOffsetPoint(details.localPosition, constraints.biggest)),
              onPanUpdate: (details) => onGestureUpdate(
                _getOffsetPoint(details.localPosition, constraints.biggest),
                _getOffsetPoint(
                  details.localPosition
                      .translate(-details.delta.dx, -details.delta.dy),
                  constraints.biggest,
                ),
              ),
              onPanEnd: (_) => onGestureEnd?.call(),
              child: CustomPaint(
                painter: WhiteboardPainer(lines),
                isComplex: true,
                willChange: true,
              ),
            ),
          ),
        ),
      );

  Point _getOffsetPoint(Offset offset, Size size) => Point(
        (offset.dx / size.width).clamp(0, 1).toDouble(),
        (offset.dy / size.width).clamp(0, 1 / aspectRatio).toDouble(),
      );
}

class WhiteboardPainer extends CustomPainter {
  const WhiteboardPainer(this._lines) : assert(_lines != null);

  final List<Line> _lines;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width / 100;

    for (final line in _lines) {
      canvas.drawPoints(
        PointMode.polygon,
        line.points.map((point) => _getPointOffset(point, size)).toList(),
        paint,
      );
    }
  }

  Offset _getPointOffset(Point point, Size size) =>
      Offset(point.x * size.width, point.y * size.width);

  @override
  bool shouldRepaint(WhiteboardPainer oldDelegate) =>
      _lines != oldDelegate._lines;
}
