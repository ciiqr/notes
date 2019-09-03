import 'package:flutter/material.dart';
import 'package:notes/enums/note_token.dart';
import 'package:rich_code_editor/rich_code_editor.dart';
import 'package:rich_code_editor/code_editor/widgets/code_editing_value.dart';

class NoteHighlighter implements CodeEditingValueHighlighterBase {
  @override
  CodeEditingValue parse({
    @required CodeEditingValue oldValue,
    @required CodeEditingValue newValue,
    @required TextStyle style,
  }) {
    // ugh
    if (_equalTextValue(oldValue, newValue)) {
      return oldValue;
    } else if (_sameTextDiffSelection(oldValue, newValue)) {
      return newValue.copyWith(value: oldValue.value);
    }
    final TextSelection newSelection = newValue.selection;

    return newValue.copyWith(
      value: buildSpan(newValue.text),
      selection: TextSelection.fromPosition(
        TextPosition(
          offset: newSelection.end,
        ),
      ),
    );
  }

  TextSpan buildSpan(String text) {
    // TODO: I really need the context here... and idk if the style param on CodeTextField even works...
    var plainStyle = TextStyle(
      color: Colors.white,
      fontSize: 16.0,
      fontFamily: "RobotoMono",
    );

    var ls = _getTextSpans(text);

    return TextSpan(text: "", style: plainStyle, children: ls);
  }

  List<TextSpan> _getTextSpans(String text) {
    List<TextSpan> ls = [];

    var lines = text.split("\n"); //splits each line
    // var space = TextSpan(text: " ");
    // var lineSpan = TextSpan(text: "\n");
    for (var line in lines) {
      // TODO: is startsWith the most logical option for this?
      if (line.startsWith(RegExp(r'([ ]*)x '))) {
        ls.add(TextSpan(
          text: line + "\n",
          style: TextStyle(
            color: NoteTokenHelper.getUiColor(NoteToken.DONE),
          ),
        ));
      } else if (line.startsWith(RegExp(r'([ ]*)- '))) {
        ls.add(TextSpan(
          text: line + "\n",
          style: TextStyle(
            color: NoteTokenHelper.getUiColor(NoteToken.TODO),
          ),
        ));
      } else if (line.startsWith(RegExp(r'([ ]*)\? '))) {
        ls.add(TextSpan(
          text: line + "\n",
          style: TextStyle(
            color: NoteTokenHelper.getUiColor(NoteToken.MAYBE),
          ),
        ));
      } else if (line.startsWith(RegExp(r'([ ]*)~ '))) {
        ls.add(TextSpan(
          text: line + "\n",
          style: TextStyle(
            fontFamily: 'RobotoMono',
            fontSize: 16.0,
            color: NoteTokenHelper.getUiColor(NoteToken.PARTIAL),
          ),
          // style: TextStyle(
          //   color: NoteTokenHelper.getUiColor(NoteToken.PARTIAL),
          // ),
        ));
      } else if (line.startsWith(RegExp(r'([ ]*)! '))) {
        ls.add(TextSpan(
          text: line + "\n",
          style: TextStyle(
            color: NoteTokenHelper.getUiColor(NoteToken.IMPORTANT),
          ),
        ));
      } else if (line.startsWith(RegExp(r'([ ]*)# '))) {
        ls.add(TextSpan(
          text: line + "\n",
          style: TextStyle(
            color: NoteTokenHelper.getUiColor(NoteToken.COMMENT),
          ),
        ));
      } else if (line.startsWith(RegExp(r'([ ]*)% '))) {
        ls.add(TextSpan(
          text: line + "\n",
          style: TextStyle(
            color: NoteTokenHelper.getUiColor(NoteToken.SECTION),
          ),
        ));
      }
      // TODO: ...
      else if (line.startsWith(RegExp(r'([ ]*)!! '))) {
        ls.add(TextSpan(
          text: line + "\n",
          style: TextStyle(
            color: NoteTokenHelper.getUiColor(NoteToken.IMPORTANT),
          ),
        ));
      } else {
        ls.add(TextSpan(
          text: line + "\n",
        ));
      }
    }

    return ls;
  }

  @override
  Map<int, TextSpan> getSpanForPosition(TextSpan parent, int targetOffset) {
    // TODO: implement getSpanForPosition
    return null;
  }

  // ugh
  static bool _equalTextValue(CodeEditingValue a, CodeEditingValue b) {
    return a.value.toPlainText() == b.value.toPlainText() &&
        a.selection == b.selection &&
        a.composing == b.composing;
  }

  bool _sameTextDiffSelection(CodeEditingValue a, CodeEditingValue b) {
    return a.value.toPlainText() == b.value.toPlainText() &&
        (a.selection != b.selection || a.composing != b.composing);
  }
}
