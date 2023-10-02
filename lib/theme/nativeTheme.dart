//flutter
// ignore_for_file: file_names

import 'package:astrologer_app/constants/colorConst.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:astrologer_app/utils/global.dart' as global;

Map<int, Color> color = {
  50: const Color.fromRGBO(198, 29, 36, .1),
  100: const Color.fromRGBO(198, 29, 36, .2),
  200: const Color.fromRGBO(198, 29, 36, .3),
  300: const Color.fromRGBO(198, 29, 36, .4),
  400: const Color.fromRGBO(198, 29, 36, .5),
  500: const Color.fromRGBO(198, 29, 36, .6),
  600: const Color.fromRGBO(198, 29, 36, .7),
  700: const Color.fromRGBO(198, 29, 36, .8),
  800: const Color.fromRGBO(198, 29, 36, .9),
  900: const Color.fromRGBO(198, 29, 36, 1),
};

class Themes {
  static final light = ThemeData.light().copyWith(
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: MaterialColor(0xffffc107, color),
    ),

    appBarTheme: AppBarTheme(
      systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      backgroundColor: COLORS().primaryColor,
      foregroundColor: COLORS().blackColor,
      elevation: 0.5,
    ),
    backgroundColor: Colors.white,

    primaryColor: const Color(0xffffc107),

    textTheme: const TextTheme(
      headline1: TextStyle(color: Colors.black),
      headline2: TextStyle(color: Colors.black),
      headline3: TextStyle(color: Colors.black),
      headline4: TextStyle(color: Colors.black),
      headline5: TextStyle(color: Colors.black), //
      headline6: TextStyle(color: Colors.black), //
      caption: TextStyle(color: Colors.black),
      subtitle1: TextStyle(color: Colors.black, fontSize: 14),
      subtitle2: TextStyle(color: Colors.black),
      bodyText1: TextStyle(color: Colors.black),
      bodyText2: TextStyle(color: Colors.black),
    ),
    primaryTextTheme: TextTheme(
      headline1: const TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 19), //APPbAR
      headline2: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16), //SignUp ma Title
      headline3: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15), // Bold Name
      headline4: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 19), //AppBar bold
      headline5: const TextStyle(color: Colors.black),
      headline6: const TextStyle(color: Colors.black),
      caption: TextStyle(color: COLORS().bodyTextColor, fontSize: 10), //bottom Bar
      subtitle1: TextStyle(color: COLORS().bodyTextColor), //Body Text ma
      subtitle2: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400), //small subtitle
      bodyText1: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400),
      bodyText2: const TextStyle(color: Colors.black),
    ),
//Card theme
    cardTheme: const CardTheme(
      margin: EdgeInsets.all(10),
      color: Colors.white,
      elevation: 0.5,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.blue,
    ),
//Textfield Decoration
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      filled: true,
      border: const OutlineInputBorder(
        borderSide: BorderSide.none,
      ),
      /* enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: Colors.grey),
      ), */
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      disabledBorder: const OutlineInputBorder(
        borderSide: BorderSide.none,
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: COLORS().primaryColor),
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
      helperStyle: TextStyle(color: COLORS().primaryColor),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(const Color(0xffffc107)),
        foregroundColor: MaterialStateProperty.all(const Color(0xFFF5F5F5)),
      ),
    ),
  );
  static final dark = ThemeData.dark().copyWith(
      backgroundColor: Colors.black,
      primaryColor: const Color(0xffffc107),
      textTheme: const TextTheme(
        headline1: TextStyle(color: Colors.black),
        headline2: TextStyle(color: Colors.black),
        headline3: TextStyle(color: Colors.black),
        headline4: TextStyle(color: Colors.black),
        headline5: TextStyle(color: Colors.white), //
        headline6: TextStyle(color: Colors.black), //
        caption: TextStyle(color: Colors.black),
        subtitle1: TextStyle(color: Colors.black),
        subtitle2: TextStyle(color: Colors.black),
        bodyText1: TextStyle(color: Colors.black),
        bodyText2: TextStyle(color: Colors.black),
      ),
      primaryTextTheme: const TextTheme(
        headline1: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 19), //
        headline2: TextStyle(color: Colors.black),
        headline3: TextStyle(color: Colors.black),
        headline4: TextStyle(color: Colors.black),
        headline5: TextStyle(color: Colors.black),
        headline6: TextStyle(color: Colors.black),
        subtitle1: TextStyle(color: Colors.black), //
        subtitle2: TextStyle(color: Colors.black),
        bodyText1: TextStyle(color: Colors.black),
        bodyText2: TextStyle(color: Colors.black),
        caption: TextStyle(color: Colors.black),
      ),
      cardTheme: CardTheme(
        margin: const EdgeInsets.all(10),
        color: Colors.blue[200],
        elevation: 0.5,
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.red,
      ));
}
