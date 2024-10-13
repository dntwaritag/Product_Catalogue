// lib/theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  // Define primary colors for different themes
  static final Color lightPrimaryColor = Colors.blue;
  static final Color darkPrimaryColor = Colors.teal;
  static final Color greenPrimaryColor = Colors.green;
  static final Color purplePrimaryColor = Colors.purple;
  static final Color orangePrimaryColor = Colors.orange;

  // Light Theme for Android
  static final ThemeData lightThemeAndroid = ThemeData(
    brightness: Brightness.light,
    primaryColor: lightPrimaryColor,
    appBarTheme: AppBarTheme(
      color: lightPrimaryColor,
    ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
    ),
  );

  // Light Theme for iOS
  static final ThemeData lightThemeIOS = ThemeData(
    brightness: Brightness.light,
    primaryColor: lightPrimaryColor,
    appBarTheme: AppBarTheme(
      color: lightPrimaryColor,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: darkPrimaryColor,
    appBarTheme: AppBarTheme(
      color: darkPrimaryColor,
    ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
    ),
  );

  // Green Theme
  static final ThemeData greenTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: greenPrimaryColor,
    appBarTheme: AppBarTheme(
      color: greenPrimaryColor,
    ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
    ),
  );

  // Purple Theme
  static final ThemeData purpleTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: purplePrimaryColor,
    appBarTheme: AppBarTheme(
      color: purplePrimaryColor,
    ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
    ),
  );

  // Orange Theme
  static final ThemeData orangeTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: orangePrimaryColor,
    appBarTheme: AppBarTheme(
      color: orangePrimaryColor,
    ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
    ),
  );

  // List of all themes for easy access
  static final List<ThemeData> allThemes = [
    lightThemeAndroid,
    darkTheme,
    greenTheme,
    purpleTheme,
    orangeTheme,
    lightThemeIOS,
  ];

  // List of theme names corresponding to the themes
  static final List<String> themeNames = [
    'Light (Android)',
    'Dark',
    'Green',
    'Purple',
    'Orange',
    'Light (iOS)',
  ];
}