import 'package:flutter/material.dart';
//변수를 다른파일에서 쓰기 싫으면 _쓰기

var theme = ThemeData(
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  iconTheme: IconThemeData(),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      splashFactory: NoSplash.splashFactory, // 스플래시 효과를 없애는 부분
    ),
  ),
  textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
    overlayColor:
        MaterialStateColor.resolveWith((states) => Colors.transparent),
  )),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.black,
  ),
  appBarTheme: AppBarTheme(
    color: Colors.white,
  ),
  textTheme: TextTheme(),
);
