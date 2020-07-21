import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whiteboard_demo/features/start_page/start_page.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Provider<Firestore>(
        create: (_) => Firestore.instance,
        child: MaterialApp(
          title: 'Whiteboard Demo',
          home: StartPage(),
        ),
      );
}
