import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/app_module.dart';

class AppGuard extends RouteGuard {
  AppGuard() : super(redirectTo: Modular.initialRoute);

  @override
  FutureOr<bool> canActivate(String path, ParallelRoute route) async {
    return await Modular.isModuleReady<AppModule>().then<bool>((_) => true);
  }
}
