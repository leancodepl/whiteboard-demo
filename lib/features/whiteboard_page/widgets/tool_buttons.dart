import 'package:flutter/material.dart';
import 'package:whiteboard_demo/features/whiteboard_page/whiteboard_view_model.dart';

class ToolButtons extends StatelessWidget {
  final WhiteboardViewModel viewmodel;

  const ToolButtons({Key key, @required this.viewmodel})
      : assert(viewmodel != null);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.edit),
          color: viewmodel.tool == Tool.pen ? Colors.black : Colors.black54,
          onPressed: () => viewmodel.selectTool(Tool.pen),
        ),
        IconButton(
          icon: Icon(Icons.delete_outline),
          color: viewmodel.tool == Tool.eraser ? Colors.black : Colors.black54,
          onPressed: () => viewmodel.selectTool(Tool.eraser),
        ),
      ],
    );
  }
}
