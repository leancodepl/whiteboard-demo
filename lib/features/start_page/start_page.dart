import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:whiteboard_demo/features/whiteboard_page/whiteboard_page.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: _controller,
                decoration: InputDecoration(hintText: 'Enter whiteboard id'),
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              RaisedButton(
                onPressed: () {
                  final id = _controller.text.isNotEmpty
                      ? _controller.text
                      : Uuid().v1();
                  return Navigator.of(context).push(WhiteboardPageRoute(id));
                },
                child: Text('Connect'),
              ),
            ],
          ),
        ),
      );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
