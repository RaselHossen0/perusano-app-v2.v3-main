import 'package:flutter/material.dart';

Map<int, Color> color = {
  50: const Color.fromRGBO(41, 182, 246, .1),
  100: const Color.fromRGBO(41, 182, 246, .2),
  200: const Color.fromRGBO(41, 182, 246, .3),
  300: const Color.fromRGBO(41, 182, 246, .4),
  400: const Color.fromRGBO(41, 182, 246, .5),
  500: const Color.fromRGBO(41, 182, 246, .6),
  600: const Color.fromRGBO(41, 182, 246, .7),
  700: const Color.fromRGBO(41, 182, 246, .8),
  800: const Color.fromRGBO(41, 182, 246, .9),
  900: const Color.fromRGBO(41, 182, 246, 1),
};

// Blue
// 50: const Color.fromRGBO(60, 175, 247, .1),
// 0xff3caaf7

MaterialColor colorCustom = MaterialColor(0xff29b6f6, color);

class AppColors {
  //static var primary = Color.fromRGBO(193, 234, 231, 100);
  // static var primary = Color.fromRGBO(255, 248, 225, 1);
  static var primary = colorCustom;
  static var secondary = const Color.fromARGB(255, 127, 214, 167);
  static var colorCalendar = const Color.fromRGBO(193, 234, 231, 1.0);
  static var colorOverview = const Color.fromRGBO(255, 248, 225, 1);
  static var colorCRED = const Color.fromRGBO(81, 209, 246, 1.0);
  static var colorCREDBoy = const Color.fromRGBO(225, 245, 254, 1.0);
  static var colorCREDGirl = const Color.fromRGBO(255, 229, 236, 1.0);
  static var colorRecipes = const Color.fromARGB(255, 255, 200, 132);
  static var colorButtonRecipes = const Color.fromARGB(219, 244, 61, 6);
  static var colorAddButtons = const Color.fromARGB(255, 244, 62, 6);
  static var colorShareExpeirence = const Color.fromARGB(255, 225, 190, 231);
  //static var colorRecetas = Color.fromRGBO(r, g, b, opacity)
  static var font_primary = Colors.black;
}
