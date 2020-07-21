import 'package:flutter/material.dart';
import 'package:whiteboard_demo/features/start_page/start_page.dart';


void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whiteboard Demo',
      home: StartPage(),
    );
  }
}
