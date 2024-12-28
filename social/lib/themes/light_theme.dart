import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
  ),
  colorScheme: ColorScheme.light(
    background: Colors.grey,
    primary: Colors.grey,
    secondary: Colors.grey,
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
    onBackground: Colors.black,
    error: Colors.red,
    onError: Colors.white,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Colors.black),
  ),
);
