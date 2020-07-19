import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';
import 'package:whiteboard_demo/features/whiteboard_page/models/line.dart';
import 'package:whiteboard_demo/features/whiteboard_page/models/point.dart';
import 'package:whiteboard_demo/features/whiteboard_page/models/whiteboard_content.dart';

class WhiteboardViewmodel extends ChangeNotifier {
  WhiteboardViewmodel(this._firestore, this._id) {
    _whiteboardRef = _firestore.collection('whiteboards').document(_id);
    _subscription = _whiteboardRef.snapshots().listen(onContentSnapshot);
  }

  final Firestore _firestore;
  final String _id;

  DocumentReference _whiteboardRef;
  StreamSubscription _subscription;

  var _content = WhiteboardContent(Uuid().v1(), <Line>[]);
  var _writtenIds = <String>[];
  Line _currentLine;

  List<Line> get lines => [
        ..._content.lines,
        if (_currentLine != null) _currentLine,
      ];

  void onGestureStart(Point point) {
    _currentLine = Line([point]);
    notifyListeners();
  }

  void onGestureUpdate(Point point) {
    _currentLine.points.add(point);
    notifyListeners();
  }

  void onGestureEnd() {
    final id = Uuid().v1();
    _content = WhiteboardContent(id, [..._content.lines, _currentLine]);
    _currentLine = null;
    _writtenIds.add(id);
    _whiteboardRef.setData(_content.toJson());
  }

  void onContentSnapshot(DocumentSnapshot snapshot) {
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
