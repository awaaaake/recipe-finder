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
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.black,
  ),
  appBarTheme: AppBarTheme(
      color: Colors.white,
      // elevation: 1,//그림자 크기
      // titleTextStyle: TextStyle(color: Colors.black, fontSize: 25),
      // actionsIconTheme: IconThemeData(color: Colors.black)
  ),
  textTheme: TextTheme(
  ),
);