import 'package:flutter/material.dart';
import 'package:health_app/BackendService/SetPreference.dart';

class ThemeClass{

  static ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(),
    primaryColor: Colors.white,     // for username/password field, appbar text
    secondaryHeaderColor: Colors.black,       // for settings page
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff71c1aa),
    ),
      // 116, 227, 245
      // canvasColor: const Color(0xff367349),
    canvasColor: const Color.fromRGBO(206, 245, 221,20),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 13)),
        // 0xff495b41
        // 0xff8ca875
        backgroundColor: MaterialStateProperty.all(const Color(0xff97ca9b)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
            ),
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xff97ca9b),
      extendedPadding: EdgeInsets.symmetric(vertical: 10),
    ),
    textTheme: const TextTheme(
      bodyText1: TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(const Color(0xff97ca9b),),
        alignment: Alignment.center,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Color(0xff367349),
      size: 32,
    ),
    backgroundColor: Colors.black,
    shadowColor: const Color(0xff495b41),
  );



  static ThemeData darkTheme = ThemeData(
      // 160,165,162,   | 141,149,136 | 199,204,210
    colorScheme: const ColorScheme.dark(),
    primaryColor: const Color.fromRGBO(141,149,136,100),
    secondaryHeaderColor: const Color.fromRGBO(191, 219, 194, 100),
    scaffoldBackgroundColor: const Color.fromRGBO(50,77,44,100),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromRGBO(115,129,114,100),
    ),
    // 116, 227, 245
    canvasColor: const Color.fromRGBO(105,132,87,100),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 13)),
        // 0xff495b41
        // 0xff8ca875
        backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(75,92,56,100)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color.fromRGBO(75,92,56,100),
      extendedPadding: EdgeInsets.symmetric(vertical: 10),
    ),
    textTheme: const TextTheme(
      bodyText1: TextStyle(
        color: Color.fromRGBO(160,165,162,100),
        fontSize: 16,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(const Color(0xff97ca9b),),
        alignment: Alignment.center,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Color.fromRGBO(235, 220, 240, 100),
      size: 32,
    ),
    backgroundColor: Colors.black,
    shadowColor: const Color(0xff495b41),
  );

}