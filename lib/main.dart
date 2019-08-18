import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NoteEditorScreen(),
    );
  }
}

class NoteEditorScreen extends StatelessWidget {
  const NoteEditorScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Lol Okay"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: new TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          ),
          new NoteStyleToolbar(),
        ],
      ),
    );
  }
}

enum NoteToken {
  DONE,
  TODO,
  MAYBE,
  PARTIAL,
  IMPORTANT,
  URGENT,
  SECTION,
}

abstract class NoteTokenHelper {
  static String getName(NoteToken noteToken) {
    switch (noteToken) {
      case NoteToken.DONE:
        return "x";
      case NoteToken.TODO:
        return "-";
      case NoteToken.MAYBE:
        return "?";
      case NoteToken.PARTIAL:
        return "~";
      case NoteToken.IMPORTANT:
        return "!";
      case NoteToken.URGENT:
        return "!!";
      case NoteToken.SECTION:
        return "%";

      default:
        throw ArgumentError.value(noteToken, noteToken.runtimeType.toString());
    }
  }

  static Color getUiColor(NoteToken noteToken) {
    switch (noteToken) {
      case NoteToken.DONE:
        return Colors.green;
      case NoteToken.TODO:
        return Colors.orange;
      case NoteToken.MAYBE:
        return Colors.blue;
      case NoteToken.PARTIAL:
        return Colors.blue;
      case NoteToken.IMPORTANT:
        return Colors.pink;
      case NoteToken.URGENT:
        return Colors.pink;
      case NoteToken.SECTION:
        return Colors.yellow.shade600;

      default:
        throw ArgumentError.value(noteToken, noteToken.runtimeType.toString());
    }
  }
}

class NoteStyleToolbar extends StatelessWidget {
  const NoteStyleToolbar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        for (var token in NoteToken.values)
          NoteStyleButton(
            text: NoteTokenHelper.getName(token),
            color: NoteTokenHelper.getUiColor(token),
            onPressed: () {
              // TODO:
            },
          )
      ],
    );
  }
}

class NoteStyleButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const NoteStyleButton({
    Key key,
    @required this.text,
    @required this.color,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: SizedBox(
          // width: 40,
          height: 40,
          child: FlatButton(
            color: Colors.grey.shade300,
            child: Text(
              text,
              style: Theme.of(context).textTheme.button.copyWith(color: color),
            ),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
