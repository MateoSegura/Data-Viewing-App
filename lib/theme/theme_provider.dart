import 'package:flutter/material.dart';

//theme: https://colorhunt.co/palette/167893

class ThemeProvider with ChangeNotifier {
  bool isLightTheme;

  ThemeProvider({this.isLightTheme});

  ThemeData get getThemeData => isLightTheme ? lightTheme : darkTheme;

  set setThemeData(bool val) {
    if (val) {
      isLightTheme = true;
    } else {
      isLightTheme = false;
    }
    notifyListeners();
  }
}

final darkTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  backgroundColor: Color(0xFF000000),
  accentColor: Colors.white,
  accentIconTheme: IconThemeData(color: Colors.black),
  dividerColor: Colors.black54,
  shadowColor: Colors.blue[900],
  floatingActionButtonTheme:
      FloatingActionButtonThemeData(backgroundColor: Color(0xff3282b8)),
  iconTheme: IconThemeData(color: Colors.red),
  appBarTheme: AppBarTheme(
    color: Color(0xff0f4c75),
  ),
);

final lightTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.white,
  brightness: Brightness.light,
  backgroundColor: Color(0xFFE5E5E5),
  accentColor: Colors.black,
  accentIconTheme: IconThemeData(color: Colors.white),
  dividerColor: Colors.white54,
  shadowColor: Colors.blue[900],
  floatingActionButtonTheme:
      FloatingActionButtonThemeData(backgroundColor: Colors.red),
  iconTheme: IconThemeData(color: Color(0xff3282b8)),
  appBarTheme: AppBarTheme(
    color: Color(0xff3282b8),
  ),
);
