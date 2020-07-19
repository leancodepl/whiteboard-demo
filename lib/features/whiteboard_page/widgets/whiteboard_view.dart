import 'package:flutter/material.dart';
import 'package:whiteboard_demo/features/whiteboard_page/models/line.dart';
import 'package:whiteboard_demo/features/whiteboard_page/models/point.dart';

const aspectRatio = 9 / 16;

class WhiteboardView extends StatelessWidget {
  const WhiteboardView({
    Key key,
    @required this.lines,
    @required this.onLineStart,
    @required this.onLinePoint,
    @required this.onLineEnd,
  })  : assert(lines != null),
        super(key: key);

  final List<Line> lines;
  final ValueChanged<Point> onLineStart;
  final ValueChanged<Point> onLinePoint;
  final VoidCallback onLineEnd;

  Widget build(BuildContext context) => Material(
        elevation: 4,
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: LayoutBuilder(
            builder: (context, constraints) => GestureDetector(
              onPanDown: (details) => onLineStart?.call(
                  _getOffsetPoint(details.localPosition, constraints.biggest)),
              onPanUpdate: (details) => onLinePoint(
                  _getOffsetPoint(details.localPosition, constraints.biggest)),
              onPanEnd: (_) => onLineEnd?.call(),
              child: CustomPaint(
                foregroundPainter: WhiteboardPainer(lines),
                isComplex: true,
                child: Container(color: Colors.white),
              ),
            ),
          ),
        ),
      );

  Point _getOffsetPoint(Offset offset, Size size) => Point(
        (offset.dx / size.width).clamp(0, 1),
        (offset.dy / size.width).clamp(0, 1 / aspectRatio),
      );
}

class WhiteboardPainer extends CustomPainter {
  const WhiteboardPainer(this._lines) : assert(_lines != null);

  final List<Line> _lines;

  @override
  void paint(Canvas canvas, Size size) {
    final _paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width / 100;

    for (final line in _lines) {
      for (var j = 0; j < line.points.length - 1; j++) {
        canvas.drawLine(
          _getPointOffset(line.points[j], size),
          _getPointOffset(line.points[j + 1], size),
          _paint,
        );
      }
    }
  }

  Offset _getPointOffset(Point point, Size size) =>
      Offset(point.x * size.width, point.y * size.width);

  @override
  bool shouldRepaint(WhiteboardPainer oldDelegate) =>
      _lines != oldDelegate._lines;
}
