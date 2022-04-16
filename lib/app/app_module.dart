import 'package:flutter_modular/flutter_modular.dart';
import 'modules/auth/auth_module.dart';
import 'modules/dashboard/dashboard_module.dart';
import 'modules/splash/splash_module.dart';
import 'shared/database/database.dart';
import 'app_core.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    // AsyncBind<AppDatabase>(
    //   (i) => $FloorAppDatabase.databaseBuilder('app_database.db').build(),
    // ),
    Bind.lazySingleton<AppCore>((i) => AppCore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: SplashModule()),
    ModuleRoute('/dashboard', module: DashboardModule()),
    ModuleRoute('/auth', module: AuthModule()),
  ];
}
