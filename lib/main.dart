import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notes/screens/note_editor_screen.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;

/// If the current platform is desktop, override the default platform to
/// a supported platform (iOS for macOS, Android for Linux and Windows).
/// Otherwise, do nothing.
void _setTargetPlatformForDesktop() {
  TargetPlatform targetPlatform;
  if (Platform.isMacOS) {
    targetPlatform = TargetPlatform.iOS;
  } else if (Platform.isLinux || Platform.isWindows) {
    targetPlatform = TargetPlatform.android;
  }
  if (targetPlatform != null) {
    debugDefaultTargetPlatformOverride = targetPlatform;
  }
}

void main() {
  _setTargetPlatformForDesktop();
  runApp(MyApp());
}

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
        textSelectionColor: Color(0xFF264F78),
      ),
      home: NoteEditorScreen(),
    );
  }
}
