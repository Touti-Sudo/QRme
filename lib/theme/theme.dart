import 'package:flutter/material.dart';

ThemeData lightmode = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.lightBlue[300],
  colorScheme: ColorScheme.light(
    surface:  Colors.grey[800]??Colors.grey,
    primary: Colors.grey[200] ?? Colors.grey,
    background: Colors.lightBlue[300],
    secondary: Colors.lightBlue,
  ),
);

ThemeData darkmode = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.lightBlue[600],
  colorScheme: ColorScheme.dark(
    surface: Colors.grey[300] ?? Colors.grey,
    primary:Colors.grey[800]??Colors.grey,
    background: Colors.lightBlue[600],
    secondary: Colors.lightBlue,
  ),
);
