import 'package:flutter/material.dart';
import 'package:notes/enums/note_token.dart';
import 'package:notes/syntax/note_highlighter.dart';
import 'package:notes/widgets/note_style_toolbar.dart';
import 'package:rich_code_editor/rich_code_editor.dart';

// TODO: remove
const TEMP_TEXT = '''
# welcome to life
% things that I care
    x things that I've done already
        details
    - things that I need to do soon
    ? things that I've considered
    ~ things that are partially done
    ! things that are important
    !! things that are very important
''';

class NoteEditorScreen extends StatefulWidget {
  NoteEditorScreen({Key key}) : super(key: key);

  _NoteEditorScreenState createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _textEditingController = TextEditingController(text: TEMP_TEXT);
  final _codeEditingController = CodeEditingController(
    // TODO: why this damn highlighter
    textSpan: NoteHighlighter().buildSpan(TEMP_TEXT),
  );

  final _textScrollController = ScrollController();
  final _codeScrollController = ScrollController();

  // TODO: consider hiding the status bar in horizontal orientation
  // TODO: would be cool if pressing and holding the token buttons would enable that one and auto apply it to all newlines
  // TODO: find a way to highlight the current line
  // TODO: preserve indentation
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  // scroll code to text offset
                  if (notification is ScrollUpdateNotification) {
                    _codeScrollController.jumpTo(_textScrollController.offset);
                  }

                  // don't stop propogation
                  return false;
                },
                child: Stack(
                  children: [
                    TextField(
                      controller: _textEditingController,
                      scrollController: _textScrollController,
                      // TODO: this MUST be the same as the other widget, also note, we add the padding here so we can still tap on the very edge to bring up the keyboard
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(8),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      expands: true,
                      onChanged: (t) {
                        // keep code text up to date
                        _codeEditingController.value =
                            _codeEditingController.value.copyWith(
                          value: NoteHighlighter().buildSpan(t),
                        );
                      },
                      // NOTE: we hide the text since sometimes the edges show through (not sure why, it's pretty rare, but I've seen it)
                      style: Theme.of(context).textTheme.subhead.copyWith(
                            color: Colors.transparent,
                          ),
                    ),
                    // NOTE: this is really dumb, but for now works surprisingly well
                    IgnorePointer(
                      child: CodeTextField(
                        controller: _codeEditingController,
                        scrollController: _codeScrollController,
                        highlighter: NoteHighlighter(),
                        onChanged: (t) {
                          // keep plain text up to date
                          _textEditingController.value =
                              _textEditingController.value.copyWith(
                            text: t,
                          );
                        },
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(8),
                        ),
                        enableInteractiveSelection: true,
                        // style: TextStyle(
                        //   fontSize: 20.0,
                        //   color: Colors.red,
                        //   fontFamily: 'RobotoMono',
                        // ),
                        // style: Theme.of(context)
                        //     .textTheme
                        //     .subhead
                        //     .copyWith(fontFamily: "RobotoMono"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                // TODO: make some shorter way of querying this: https://pub.dev/packages/keyboard_visibility
                bottom: MediaQuery.of(context).viewInsets.bottom == 0 ? 8.0 : 0,
              ),
              child: NoteStyleToolbar(
                onNoteTokenPressed: (NoteToken noteToken) {
                  var prefix = NoteTokenHelper.getName(noteToken) + " ";
                  toggleReplacementLinePrefixes(prefix);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TODO: decide if it's readonable to toggle the prefixes line by line, or if all should be toggled as one (ie. for prefixes which match an existing prefix)
  void toggleReplacementLinePrefixes(String prefix) {
    final value = _textEditingController.value;
    if (!value.selection.isValid) {
      return;
    }

    final start = value.selection.start;
    final end = value.selection.end;
    var newText = value.text;
    var newStart = start;
    var newEnd = end;

    var index = end;
    while (index >= start) {
      // TODO: consider if we have CR's... (check how flutter on windows/web handles things) (regardless we need to be able to open files with CRLF) (actually, it should probablt just be fine, so long as we don't have just CR on it's own, fuckin' legacy macs)
      // find the lastIndexOf NL character pattern OR the beginning of the string
      // NOTE: because of how we're doing things, and the fact that lastIndexOf return -1 on no match, the math just works out fine at the beginning of the string, but if we change that math, we may need to handle -1 from lastIndexOf specially
      var indexOfNewline = value.text.lastIndexOf(RegExp(r'(\n)'), index);
      // TODO: there's a probably a less dumb way of doing this
      // make sure toggling when on the end of a line toggles that line not the next
      if (index == indexOfNewline) {
        indexOfNewline = value.text.lastIndexOf(RegExp(r'(\n)'), index - 1);
      }
      // TODO: pretty sure the -1 is required to prevent extra looping
      index = indexOfNewline - 1;

      // TODO: is it even possible to get null now? basically just with bugs
      // TODO: don't think the +1 is okay for the beginning...
      // TODO: make this matching smarter
      // if the character range starting after the newline startsWith an existing prefix:
      final tokenMatchRegex = RegExp(r'([ ]*)([x\-\?~!#%] |!! )?');
      var match = tokenMatchRegex.matchAsPrefix(value.text, index + 2);
      var existingPrefix = match[2];
      if (existingPrefix != null && existingPrefix.length != 0) {
        // if it also starts with the same prefix as the replacement prefix
        if (prefix == existingPrefix) {
          // remove the prefix
          newText = newText.replaceRange(
              match.end - existingPrefix.length, match.end, '');
          // if selection ends after the changed region, subtract existingPrefix.length from end
          if (newEnd >= match.end) {
            newEnd -= existingPrefix.length;
          }
          // else if selection ends in the middle of the prefix, move end to where the prefix previously began
          else if (newEnd > match.end - existingPrefix.length) {
            newEnd = match.end - existingPrefix.length;
          }
          // if selection starts after the changed region, subtract existingPrefix.length from start
          if (newStart >= match.end) {
            newStart -= existingPrefix.length;
          }
          // else if selection starts in the middle of the prefix, move start to where the prefix previously began
          else if (newStart > match.end - existingPrefix.length) {
            newStart = match.end - existingPrefix.length;
          }
        } else {
          // replace the existing prefix with the new one
          newText = newText.replaceRange(
              match.end - existingPrefix.length, match.end, prefix);
          // TODO: for this & next selection changes, try to preserve within prefix when simply changing the prefix
          // if selection ends after the changed region, subtract existingPrefix.length from end
          if (newEnd >= match.end) {
            newEnd -= (existingPrefix.length - prefix.length);
          }
          // else if selection ends in the middle of the prefix, move end to where the prefix previously began
          else if (newEnd > match.end - existingPrefix.length) {
            newEnd = match.end - (existingPrefix.length - prefix.length);
          }
          // if selection starts after the changed region, subtract existingPrefix.length from start
          if (newStart >= match.end) {
            newStart -= (existingPrefix.length - prefix.length);
          }
          // else if selection starts in the middle of the prefix, move start to where the prefix previously began
          else if (newStart > match.end - existingPrefix.length) {
            newStart = match.end - (existingPrefix.length - prefix.length);
          }
        }
      } else {
        // insert the new prefix
        newText = newText.replaceRange(match.end, match.end, prefix);
        // if selection ends at the leading whitespace, add the prefix.length to the end
        if (newEnd >= match.end) {
          newEnd += prefix.length;
        }
        // if selection starts at the leading whitespace, add the prefix.length to the start
        if (newStart >= match.end) {
          newStart += prefix.length;
        }
      }
    }

    setState(() {
      _codeEditingController.value = _codeEditingController.value.copyWith(
        value: NoteHighlighter().buildSpan(newText),
      );
      _textEditingController.value = value.copyWith(
        text: newText,
        selection: value.selection.copyWith(
          baseOffset: newStart,
          extentOffset: newEnd,
        ),
      );
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
