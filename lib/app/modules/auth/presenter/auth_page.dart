import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return const Material(
      child: RouterOutlet(),
    );
  }
}
