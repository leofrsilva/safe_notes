import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:safe_notes/app/design/common/common.dart';

import '../../../app_module.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<String> _getVersion() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final info = await PackageInfo.fromPlatform();
      return info.version;
    }
    return '';
  }

  _startSplashPage() async {
    await Future.wait([
      Modular.isModuleReady<AppModule>(),
      Future.delayed(const Duration(seconds: 2)),
    ]).then((value) async {
      //...
      // Modular.to.navigate('/dashboard/movie_module/');
    });
  }

  @override
  void initState() {
    super.initState();
    _startSplashPage();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
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
                    color: ColorPalettes.white,
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
                      seeInfo = 'v ${snapshot.data}';
                    }
                  }

                  return Container(
                    margin: EdgeInsets.only(bottom: Sizes.dp28(context)),
                    child: Text(
                      seeInfo,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorPalettes.white,
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
