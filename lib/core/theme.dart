import 'package:flutter/material.dart';

abstract final class Palette {
  static const ink = Color(0xFF191E24);
  static const muted = Color(0xFF8D9CAE);
  static const body = Color(0xFF505B6B);
  static const background = Color(0xFFF5F8FA);
  static const line = Color(0xFFD6E0EC);
  static const blue = Color(0xFFC2D3F0);
  static const green = Color(0xFFB2DDA8);
  static const sand = Color(0xFFDFD2CD);
}

ThemeData appTheme() => ThemeData(
  useMaterial3: true,
  fontFamily: 'Archivo',
  scaffoldBackgroundColor: Palette.background,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Palette.ink,
    primary: Palette.ink,
    secondary: Palette.green,
    surface: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(fontSize: 16, height: 1.4, color: Palette.ink),
    bodyLarge: TextStyle(fontSize: 16, color: Palette.ink),
    titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.transparent,
    centerTitle: false,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontFamily: 'Archivo',
      fontSize: 24,
      color: Palette.ink,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
    labelStyle: const TextStyle(color: Palette.muted, fontSize: 14),
    hintStyle: const TextStyle(color: Palette.muted),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: const BorderSide(color: Palette.line),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: const BorderSide(color: Palette.line),
    ),
  ),
  dividerTheme: const DividerThemeData(
    color: Palette.line,
    thickness: .7,
    space: 24,
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: Palette.ink,
      foregroundColor: Colors.white,
      minimumSize: const Size(double.infinity, 54),
      textStyle: const TextStyle(
        fontFamily: 'Archivo',
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      shape: const StadiumBorder(),
      elevation: 0,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Palette.ink,
      minimumSize: const Size(double.infinity, 54),
      side: const BorderSide(color: Palette.ink),
      shape: const StadiumBorder(),
    ),
  ),
  snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
);
