import 'package:flutter/material.dart';
import 'package:sounds/themes/dark_mode.dart';
import 'package:sounds/themes/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightTheme;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkTheme;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() { 
    if (_themeData == lightTheme) {
      _themeData = darkTheme; 
    } else {
      _themeData = lightTheme; 
    }
    notifyListeners();
  }
}
