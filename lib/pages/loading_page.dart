import 'package:flutter/material.dart';
import 'package:bechan/theme/theme.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

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
              const SizedBox(height: 350,),
              const CircularProgressIndicator(),
              // const RefreshProgressIndicator(),
            ]
          ),
        )
      ),
    );
  }
}
