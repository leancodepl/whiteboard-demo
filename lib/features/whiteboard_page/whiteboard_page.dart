import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whiteboard_demo/features/whiteboard_page/whiteboard_view_model.dart';
import 'package:whiteboard_demo/features/whiteboard_page/widgets/tool_buttons.dart';
import 'package:whiteboard_demo/features/whiteboard_page/widgets/whiteboard_view.dart';

class WhiteboardPage extends StatelessWidget {
  const WhiteboardPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WhiteboardViewModel>(
      builder: (context, viewmodel, _) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Stack(
                children: <Widget>[
                  WhiteboardView(
                    lines: viewmodel.lines,
                    onGestureStart: viewmodel.onGestureStart,
                    onGestureUpdate: viewmodel.onGestureUpdate,
                    onGestureEnd: viewmodel.onGestureEnd,
                  ),
                  ToolButtons(viewmodel: viewmodel),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WhiteboardPageRoute extends MaterialPageRoute<void> {
  WhiteboardPageRoute(String id)
      : super(
          builder: (context) => ChangeNotifierProvider<WhiteboardViewModel>(
            create: (context) {
              final firestore = Provider.of<Firestore>(context, listen: false);
              return WhiteboardViewModel(firestore, id);
            },
            child: WhiteboardPage(),
          ),
        );
}
