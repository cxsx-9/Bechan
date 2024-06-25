import 'package:bechan/models/secure_storage.dart';
import 'package:bechan/pages/main_page.dart';
import 'package:bechan/pages/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'package:flutter/services.dart';
import 'theme/theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]); // Preferred Portrait

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool?>(
        future: SecureStorage().isTokenValid(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null && snapshot.data == true) {
            return const MainPage();
          }
          return const LoginPage();
        },
      ),
      theme: Provider.of<ThemeProvider>(context).themeData,
      routes: {
        '/loginPage': (context) => const LoginPage(),
        '/registerPage': (context) => const RegisterPage(),
        '/homePage': (context) => HomePage(),
        '/mainPage': (context) => const MainPage(),
        '/settingPage': (context) => const SettingPage(),
      },
    );
  }
}
