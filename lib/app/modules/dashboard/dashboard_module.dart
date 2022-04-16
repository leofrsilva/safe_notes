import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/shared/token/expire_token.dart';
import 'package:safe_notes/app/shared/token/i_expire_token.dart';

import 'presenter/pages/drawer_menu_controller.dart';
import 'presenter/dashboard_controller.dart';
import 'presenter/dashboard_page.dart';
import 'submodules/home/home_module.dart';

class DashboardModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        // Bind.lazySingleton<IAuthenticationSqliteDatasource>(
        //   (i) => AuthenticationSqliteDatasource(i<AppDatabase>().usuarioDao),
        // ),
        // Bind.lazySingleton<IAuthenticationSqliteRepository>(
        //   (i) => AuthenticationSqliteRepository(
        //       i<IAuthenticationSqliteDatasource>()),
        // ),
        // Bind.lazySingleton<ILogoutUserSqliteUsecase>(
        //   (i) => LogoutUserSqliteUsecase(i<IAuthenticationSqliteRepository>()),
        // ),
        Bind.lazySingleton<IExpireToken>((i) => ExpireToken()),
        Bind.lazySingleton<DashboardController>((i) => DashboardController(
              i<IExpireToken>(),
              FirebaseAuth.instance,
              // i<ILogoutUserSqliteUsecase>(),
            )),

        Bind.singleton((i) => DrawerMenuController()),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(Modular.initialRoute,
            child: (_, __) => DashboardPage(),
            children: [
              ModuleRoute('/home', module: HomeModule()),
            ]),
      ];
}
