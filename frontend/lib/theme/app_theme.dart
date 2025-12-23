import 'package:flutter/material.dart';
import 'package:task_1_attendance/theme/colors.dart';

class AppTheme{
  static ThemeData theme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    dialogBackgroundColor: Colors.white,
    primaryColor: ColorPalette.accent,
    colorScheme: ColorScheme.light(
      primary: ColorPalette.accent,
      secondary: ColorPalette.accent,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: ColorPalette.accent,
      selectionColor: ColorPalette.accent.withOpacity(0.3),
      selectionHandleColor: ColorPalette.accent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.never,
      labelStyle: TextStyle(color: ColorPalette.accent),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorPalette.accent, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorPalette.accent),
      ),
    ),
  );
}