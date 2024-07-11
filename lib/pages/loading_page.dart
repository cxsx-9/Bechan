import 'package:flutter/material.dart';
import 'package:bechan/theme/theme.dart';
import 'package:provider/provider.dart';

import 'dart:async';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  bool _showButton = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _showButton = true;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 200,),
              Image.asset(
                Provider.of<ThemeProvider>(context, listen: false).isDarkMode
                    ? 'assets/Banche_logo_dark.png'
                    : 'assets/Banche_logo_light.png',
                height: 83,
              ),
              SizedBox(
                height: 350,
                child : Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Column(
                    children: [
                      if (_showButton)
                        const Text('This process is taking longer than expected.'),
                      if (_showButton)
                        FilledButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/loginPage');
                          },
                          child: const Text('Go Back'),
                        ),
                    ],
                  ),
                ),
              ),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
