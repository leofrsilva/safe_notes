import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/app_core.dart';
import 'package:safe_notes/app/shared/database/database.dart';

import 'package:safe_notes/app/shared/leave/leave.dart';
import 'package:safe_notes/app/shared/token/expire_token.dart';
import '../setting/presenter/controllers/access_boot_store.dart';
import 'splash_page.dart';
import 'splash_controller.dart';

class SplashModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.lazySingleton<ILeaveDatasource>(
          (i) => LeaveDatasource(
            FirebaseAuth.instance,
            FirebaseFirestore.instance,
          ),
        ),
        Bind.lazySingleton<ILeaveRepository>(
          (i) => LeaveRepository(i<ILeaveDatasource>()),
        ),
        Bind.lazySingleton<ILeaveAuthUsecase>(
          (i) => LeaveAuthUsecase(i<ILeaveRepository>()),
        ),
        //
        Bind.lazySingleton<SplashController>((i) => SplashController(
              i<AppCore>(),
              ExpireToken(),
              i<AccessBootStore>(),
              i<ILeaveAuthUsecase>(),
            )),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(Modular.initialRoute, child: (_, __) => const SplashPage()),
      ];
}
