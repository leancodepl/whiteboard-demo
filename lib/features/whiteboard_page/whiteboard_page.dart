import 'package:flutter/material.dart';

class WhiteboardPage extends StatelessWidget {
  const WhiteboardPage({Key key, this.id})
      : assert(id != null),
        super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) => Scaffold();
}

class WhiteboardPageRoute extends MaterialPageRoute<void> {
  WhiteboardPageRoute(String id)
      : super(builder: (context) => WhiteboardPage(id: id));
}
