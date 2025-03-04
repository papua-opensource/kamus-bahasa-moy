import 'package:flutter/material.dart';

// File pusat untuk mengelola tema aplikasi

class ThemeConfig {
  // Warna primer aplikasi
  static const Color primaryColor = Color(0xFF164B8F);

  // AppBar theme dengan warna teks dan icon putih
  static final AppBarTheme appBarTheme = AppBarTheme(
    backgroundColor: primaryColor,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  );

  // Theme data aplikasi
  static final ThemeData themeData = ThemeData(
    primaryColor: primaryColor,
    appBarTheme: appBarTheme,
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: primaryColor,
      secondary: primaryColor,
    ),
  );
}
