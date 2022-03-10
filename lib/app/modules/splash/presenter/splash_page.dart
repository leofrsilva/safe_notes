import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future _getVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

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
