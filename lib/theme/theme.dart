import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;
  ThemeData get themeData => _themeData;
  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
    print(isDarkMode ? "Dark" : "Light");
  }
}

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: Colors.black,
    onPrimary: Colors.white,
    secondary: Colors.grey.shade400,
    onSecondary: Colors.grey.shade200,
    surface: Colors.white,
    // inversePrimary: Colors.grey.shade800,
    // error: Colors.red,
    // onSecondary: Colors.black,
    // onSurface: Colors.black,
    // onError: Colors.white,
  )
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: Colors.grey.shade200,
    onPrimary: Colors.grey.shade900,
    secondary: Colors.grey.shade600,
    onSecondary: Colors.grey.shade800,
    surface: const Color.fromARGB(255, 33, 33, 33),
  )
);