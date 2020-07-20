import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';
import 'package:whiteboard_demo/features/whiteboard_page/models/line.dart';
import 'package:whiteboard_demo/features/whiteboard_page/models/point.dart';
import 'package:whiteboard_demo/features/whiteboard_page/models/whiteboard_content.dart';

enum Tool { pen, eraser }

class WhiteboardViewmodel extends ChangeNotifier {
  WhiteboardViewmodel(this._firestore, this._id) {
    _whiteboardRef = _firestore.collection('whiteboards').document(_id);
    _subscription = _whiteboardRef.snapshots().listen(_onContentSnapshot);
  }

  final Firestore _firestore;
  final String _id;

  DocumentReference _whiteboardRef;
  StreamSubscription _subscription;

  var _content = WhiteboardContent(Uuid().v1(), <Line>[]);
  var _writtenIds = <String>[];
  Line _currentLine;
  Tool _tool = Tool.pen;

  List<Line> get lines => [
        ..._content.lines,
        if (_currentLine != null) _currentLine,
      ];

  Tool get tool => _tool;

  void onGestureStart(Point point) {
    if (_tool == Tool.pen) {
      _currentLine = Line([point]);
      notifyListeners();
    } else {
      _remove(point);
    }
  }

  void onGestureUpdate(Point point, Point previousPoint) {
    if (_tool == Tool.pen) {
      _currentLine.points.add(point);
      notifyListeners();
    } else {
      _remove(point, previousPoint);
    }
  }

  void onGestureEnd() {
    if (_tool == Tool.pen) {
      final id = Uuid().v1();
      _content = WhiteboardContent(id, [..._content.lines, _currentLine]);
      _currentLine = null;
      _writtenIds.add(id);
      _whiteboardRef.setData(_content.toJson());
    }
  }

  void selectTool(Tool tool) {
    _tool = tool;
    notifyListeners();
  }

  void _remove(Point point1, [Point point2]) {
    point2 ??= point1;

    print('${point1.x} ${point1.y} ${point2.x} ${point2.y}');

    final lines = _content.lines.where((line) {
      if (line.points.length == 1) {
        final point = line.points.first;
        return _rectanglesInterect(
          Point(point.x - 0.01, point.y - 0.01),
          Point(point.x + 0.01, point.y + 0.01),
          point1,
          point1,
        );
      } else {
        for (var i = 0; i < line.points.length - 1; i++) {
          if (_rectanglesInterect(
              line.points[i], line.points[i + 1], point1, point2)) {
            return false;
          }
        }
        return true;
      }
    }).toList();

    if (lines.length != _content.lines.length) {
      _content = WhiteboardContent(Uuid().v1(), lines);
      notifyListeners();
    }
  }

  bool _rectanglesInterect(
    Point point11,
    Point point12,
    Point point21,
    Point point22,
  ) =>
      _rectangleContainsPoint(point11, point12, point21) ||
      _rectangleContainsPoint(point11, point12, point22) ||
      _rectangleContainsPoint(point21, point22, point11);

  bool _rectangleContainsPoint(
          Point rectangle1, Point rectangle2, Point contained) =>
      contained.x >= min(rectangle1.x, rectangle2.x) &&
      contained.x <= max(rectangle1.x, rectangle2.x) &&
      contained.y >= min(rectangle1.y, rectangle2.y) &&
      contained.y <= max(rectangle1.y, rectangle2.y);

  void _onContentSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.data == null) {
      return;
    }

    final content = WhiteboardContent.fromJson(snapshot.data);

    if (!_writtenIds.contains(content.id)) {
      _content = content;
    } else {
      _writtenIds = _writtenIds.sublist(_writtenIds.indexOf(content.id) + 1);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
