import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData themeData = ThemeData();

final theme = themeData.copyWith(
  colorScheme: themeData.colorScheme.copyWith(
    primary: Colors.deepPurple.shade600,
    primaryVariant: Colors.deepPurple.shade300,
    secondary: Colors.grey.shade600,
    background: Colors.deepPurple.shade500,
    surface: Colors.deepPurple.shade400,
    onSurface: Colors.grey.shade200,
    onBackground: Colors.blueGrey.shade200,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.deepPurple.shade500,
  ),
  scaffoldBackgroundColor: Colors.deepPurple.shade500,
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.grey.shade800,
  ),
  textTheme: TextTheme(
    bodyText1: GoogleFonts.flamenco(
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 26,
      ),
    ),
    bodyText2: GoogleFonts.roboto(
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 24,
      ),
    ),
  ),
);
