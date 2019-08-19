import 'package:flutter/material.dart';

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
          height: 40,
          child: OutlineButton(
            shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.elliptical(5, 5)),
            ),
            textColor: color,
            highlightedBorderColor: color,
            child: Text(text),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
