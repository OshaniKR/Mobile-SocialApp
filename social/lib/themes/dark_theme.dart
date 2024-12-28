import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
  ),
  colorScheme: ColorScheme.dark(
    background: Colors.black,
    primary: Colors.grey,
    secondary: Colors.grey,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    surface: Colors.grey[850]!,
    onSurface: Colors.white,
    onBackground: Colors.white,
    error: Colors.red,
    onError: Colors.white,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Colors.white),
  ),
);
