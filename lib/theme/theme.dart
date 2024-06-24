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
    surfaceBright: Colors.white,
    surface: const Color(0xFFF5F5F5),
    shadow: const Color.fromARGB(12, 0, 0, 0),
  )
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: Colors.grey.shade200,
    onPrimary: Colors.black,
    secondary: Colors.grey.shade600,
    onSecondary: Colors.grey.shade800,
    surface: const Color(0xFF212121),
    surfaceBright: Colors.black,
    shadow: Colors.black38,
  )
);