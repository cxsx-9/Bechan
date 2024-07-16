import 'package:flutter/material.dart';
import 'package:bechan/config.dart' as config;

class LogPage extends StatelessWidget {
  const LogPage({super.key});
  @override
  Widget build(BuildContext context) {
    if (config.LOG.length > 4000) {
      config.LOG = "${config.LOG.substring(0, 4000 - 3)}...";
    }
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  const Text('LOG'),
                  SizedBox(
                    width: double.infinity,
                    child: Text(config.LOG),
                  )
                ],
              ),
            ),
          ),
        ),
      );
  }
}