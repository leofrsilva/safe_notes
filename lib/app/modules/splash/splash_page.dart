import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:safe_notes/app/app_module.dart';
import 'package:safe_notes/app/design/common/common.dart';

import 'splash_module.dart';
import 'splash_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late SplashController store;

  Future<String> _getVersion() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final info = await PackageInfo.fromPlatform();
      return info.version;
    }
    return '';
  }

  _startSplashPage(BuildContext context) async {
    await Future.wait([
      Modular.isModuleReady<AppModule>(),
      Modular.isModuleReady<SplashModule>(),
      Future.delayed(const Duration(milliseconds: 500)),
      Future.delayed(const Duration(milliseconds: 10000)),
    ]).then((_) async {
      await store.checkLoggedInUser(context);
    });
  }

  @override
  void initState() {
    super.initState();
    store = Modular.get<SplashController>();
    _startSplashPage(context);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Theme.of(context).brightness,
      statusBarBrightness: Theme.of(context).brightness,
      statusBarIconBrightness: Theme.of(context).brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light,
    ));

    return Material(
      color: Theme.of(context).brightness == Brightness.light
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.onPrimary,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    ImagesAssets.imgSplah,
                    key: const ValueKey('img-splash'),
                    fit: BoxFit.cover,
                    width: 128,
                  ),
                  SizedBox(height: Sizes.dp30(context)),
                  CircularProgressIndicator(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).colorScheme.onBackground
                        : Theme.of(context).colorScheme.background,
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: FutureBuilder<String>(
                future: _getVersion(),
                builder: (context, snapshot) {
                  var seeInfo = '';
                  if (snapshot.hasData) {
                    if (snapshot.data!.isNotEmpty) {
                      seeInfo = 'v${snapshot.data}';
                    }
                  }

                  return Container(
                    margin: EdgeInsets.only(bottom: Sizes.dp28(context)),
                    child: Text(
                      seeInfo,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).colorScheme.onBackground
                            : Theme.of(context).colorScheme.background,
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
