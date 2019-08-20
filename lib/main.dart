import 'package:flutter/material.dart';
import 'package:notes/screens/note_editor_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      theme: ThemeData(
        fontFamily: 'RobotoMono',
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFF272822),
        textTheme: Theme.of(context).textTheme.copyWith(
              subhead: TextStyle(color: Colors.white),
            ),
      ),
      home: NoteEditorScreen(),
    );
  }
}
