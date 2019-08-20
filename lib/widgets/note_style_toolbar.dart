import 'package:flutter/material.dart';
import 'package:notes/enums/note_token.dart';
import 'package:notes/widgets/note_style_button.dart';

typedef NoteTokenCallback = void Function(NoteToken noteToken);

// TODO: maybe rename to NoteTokenToolbar?
class NoteStyleToolbar extends StatelessWidget {
  final NoteTokenCallback onNoteTokenPressed;

  const NoteStyleToolbar({
    Key key,
    @required this.onNoteTokenPressed,
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
              onNoteTokenPressed(token);
            },
          )
      ],
    );
  }
}
