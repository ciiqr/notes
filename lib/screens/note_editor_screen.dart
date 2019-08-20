import 'package:flutter/material.dart';
import 'package:notes/enums/note_token.dart';
import 'package:notes/widgets/note_style_toolbar.dart';

class NoteEditorScreen extends StatefulWidget {
  NoteEditorScreen({Key key}) : super(key: key);

  _NoteEditorScreenState createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _textEditingController = TextEditingController();

  // TODO: consider hiding the status bar in horizontal orientation
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                // TODO: find a way to highlight the current line
                child: TextField(
                  controller: _textEditingController,
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
                  insertText(NoteTokenHelper.getName(noteToken) + " ");
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

  // TODO: cleanup code
  // TODO: I actually want to insert at the beginning of the line, and replace the existing prefix
  void insertText(String text) {
    var value = _textEditingController.value;
    var start = value.selection.baseOffset;
    var end = value.selection.extentOffset;
    if (value.selection.isValid) {
      String newText = "";
      if (value.selection.isCollapsed) {
        if (end > 0) {
          newText += value.text.substring(0, end);
        }
        newText += text;
        if (value.text.length > end) {
          newText += value.text.substring(end, value.text.length);
        }
      } else {
        newText = value.text.replaceRange(start, end, text);
      }

      setState(() {
        //FocusScope.of(context).requestFocus(_focusNode);
        _textEditingController.value = value.copyWith(
            text: newText,
            selection: value.selection.copyWith(
                baseOffset: end + text.length,
                extentOffset: end + text.length));
      });
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
