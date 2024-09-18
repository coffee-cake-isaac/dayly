import 'dart:ui';

import 'package:flutter/material.dart';

abstract class CustomThemes {
  static TextStyle styledPlainText = TextStyle(
    color: Colors.white,
  );

  static UnderlineInputBorder styledInputBorderWhite =
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.white));

  static InputDecoration getDecor(String labelText) {
    return InputDecoration(
        enabledBorder: CustomThemes.styledInputBorderWhite,
        focusedBorder: CustomThemes.styledInputBorderWhite,
        border: UnderlineInputBorder(),
        focusColor: Colors.white,
        hintStyle: CustomThemes.styledPlainText,
        fillColor: Colors.white,
        labelText: labelText,
        labelStyle: CustomThemes.styledPlainText);
  }
}
