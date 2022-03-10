import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Image.asset(
          '',
          key: const ValueKey('img-splash'),
          fit: BoxFit.cover,
          width: 200,
        ),
      ),
    );
  }
}
