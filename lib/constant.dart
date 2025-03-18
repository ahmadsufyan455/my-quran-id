import 'package:flutter/material.dart';

const darkColor = Color(0XFF040C23);
const lightColor = Color(0XFFFFFFFF);
const purpleColor = Color(0XFFA44AFF);
const darkerGreyColor = Color(0XFF121931);
const greyColor = Color(0XFFA19CC5);

final themeData = ThemeData(
  useMaterial3: true,
  fontFamily: 'Nunito',
  scaffoldBackgroundColor: darkColor,
  appBarTheme: const AppBarTheme(
    backgroundColor: darkColor,
    elevation: 0,
    iconTheme: IconThemeData(color: lightColor),
    titleTextStyle: TextStyle(
      color: lightColor,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      fontFamily: 'Nunito',
    ),
    actionsIconTheme: IconThemeData(color: lightColor),
  ),
);
