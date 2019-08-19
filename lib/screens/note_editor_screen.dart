import 'package:flutter/material.dart';
import 'package:notes/enums/note_token.dart';
import 'package:notes/widgets/note_style_toolbar.dart';

class NoteEditorScreen extends StatelessWidget {
  const NoteEditorScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              // TODO: find a way to highlight the current line
              child: Padding(
                // TODO: decide if padding or not...
                // padding: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(8),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(0),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  expands: true,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                // TODO: make some shorter way of querying this: https://pub.dev/packages/keyboard_visibility
                // TODO: do I want the padding in horizontal mode?
                bottom: MediaQuery.of(context).viewInsets.bottom == 0 ? 8.0 : 0,
              ),
              // TODO: ? maybe, still not sure, have the current lines token highlighted already...
              child: NoteStyleToolbar(
                onNoteTokenPressed: (NoteToken noteToken) {
                  // TODO: this will change/toggle the note token for the current line OR all selected lines
                  print("=============" + NoteTokenHelper.getName(noteToken));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
