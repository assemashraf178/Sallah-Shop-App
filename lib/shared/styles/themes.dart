import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

import 'colors.dart';

ThemeData darkTheme() => ThemeData(
      hintColor: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      splashColor: HexColor('333739'),
      primarySwatch: defaultColor,
      scaffoldBackgroundColor: HexColor('333739'),
      appBarTheme: AppBarTheme(
        color: HexColor('333739'),
        elevation: 0.0,
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: HexColor('333739'),
          statusBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: defaultColor,
        backgroundColor: HexColor('333739'),
        unselectedItemColor: Colors.grey,
      ),
      textTheme: TextTheme(
        bodyText1: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyText2: TextStyle(
          color: Colors.white,
        ),
        button: TextStyle(
          color: Colors.white,
        ),
        headline1: TextStyle(
          color: Colors.white,
        ),
        caption: TextStyle(
          color: Colors.white,
        ),
        overline: TextStyle(
          color: Colors.white,
        ),
        headline2: TextStyle(
          color: Colors.white,
        ),
        headline3: TextStyle(
          color: Colors.white,
        ),
        headline4: TextStyle(
          color: Colors.white,
        ),
        headline5: TextStyle(
          color: Colors.white,
        ),
        headline6: TextStyle(
          color: Colors.white,
        ),
        subtitle1: TextStyle(
          color: Colors.white,
        ),
        subtitle2: TextStyle(
          color: Colors.white,
        ),
      ),
      fontFamily: 'Jannah',
    );

ThemeData lightTheme() => ThemeData(
      primarySwatch: defaultColor,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        color: Colors.white,
        elevation: 0.0,
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: defaultColor,
      ),
      textTheme: TextTheme(
        bodyText1: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        bodyText2: TextStyle(
          color: Colors.black,
        ),
        button: TextStyle(
          color: Colors.black,
        ),
        headline1: TextStyle(
          color: Colors.black,
        ),
        caption: TextStyle(
          color: Colors.black,
        ),
        overline: TextStyle(
          color: Colors.black,
        ),
        headline2: TextStyle(
          color: Colors.black,
        ),
        headline3: TextStyle(
          color: Colors.black,
        ),
        headline4: TextStyle(
          color: Colors.black,
        ),
        headline5: TextStyle(
          color: Colors.black,
        ),
        headline6: TextStyle(
          color: Colors.black,
        ),
        subtitle1: TextStyle(
          color: Colors.black,
        ),
        subtitle2: TextStyle(
          color: Colors.black,
        ),
      ),
      fontFamily: 'Jannah',
    );
