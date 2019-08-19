import 'package:flutter/material.dart';

// TODO: decide on urgent...
enum NoteToken {
  DONE,
  TODO,
  MAYBE,
  PARTIAL,
  IMPORTANT,
  // URGENT,
  COMMENT,
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
      case NoteToken.COMMENT:
        return "#";
      // case NoteToken.URGENT:
      //   return "!!";
      case NoteToken.SECTION:
        return "%";

      default:
        throw ArgumentError.value(noteToken, noteToken.runtimeType.toString());
    }
  }

  static Color getUiColor(NoteToken noteToken) {
    switch (noteToken) {
      case NoteToken.DONE:
        // return Colors.green;
        return Color(0xFFA6E22E);
      case NoteToken.TODO:
        // return Colors.orange;
        return Color(0xFFFD971F);
      case NoteToken.MAYBE:
        // return Colors.blue;
        return Color(0xFF66D9EF);
      case NoteToken.PARTIAL:
        // return Colors.blue;
        return Color(0xFF66D9EF);
      case NoteToken.IMPORTANT:
        // return Colors.pink;
        return Color(0xFFF92672);
      case NoteToken.COMMENT:
        return Color(0xFF75715E);
      // case NoteToken.URGENT:
      //   // return Colors.pink;
      //   return Color(0xFFF92672);
      case NoteToken.SECTION:
        // return Colors.yellow.shade600;
        return Color(0xFFE6DB74);

      default:
        throw ArgumentError.value(noteToken, noteToken.runtimeType.toString());
    }
  }
}
