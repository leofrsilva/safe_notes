import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:safe_notes/app/shared/database/database.dart';
import 'package:safe_notes/app/shared/token/expire_token.dart';
import 'package:safe_notes/app/shared/token/i_expire_token.dart';

import 'splash_page.dart';
import 'splash_store.dart';

class SplashModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        // Bind.lazySingleton<IAuthenticationSqliteDatasource>(
        //   (i) => AuthenticationSqliteDatasource(i<AppDatabase>().usuarioDao),
        // ),
        // Bind.lazySingleton<IAuthenticationSqliteRepository>(
        //   (i) => AuthenticationSqliteRepository(
        //       i<IAuthenticationSqliteDatasource>()),
        // ),
        // Bind.lazySingleton<ILogoutUserSqliteUsecase>((i) =>
        //     LogoutUserSqliteUsecase(i<IAuthenticationSqliteRepository>())),
        // Bind.lazySingleton<IGetUsersLoggedSqliteUsecase>((i) =>
        //     GetUsersLoggedSqliteUsecase(i<IAuthenticationSqliteRepository>())),
        //
        Bind.lazySingleton<IExpireToken>((i) => ExpireToken()),
        Bind.lazySingleton<SplashStore>((i) => SplashStore(
              i<IExpireToken>(),
              FirebaseAuth.instance,
              // i<LogoutUserSqliteUsecase>(),
              // i<IGetUsersLoggedSqliteUsecase>(),
            )),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(Modular.initialRoute, child: (_, __) => const SplashPage()),
      ];
}
