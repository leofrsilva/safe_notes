import 'package:flutter_modular/flutter_modular.dart';
import 'app_guard.dart';
import 'modules/auth/auth_module.dart';
import 'modules/dashboard/dashboard_module.dart';
import 'modules/setting/presenter/controllers/first_boot_store.dart';
import 'modules/setting/presenter/controllers/setting_controller.dart';
import 'modules/setting/presenter/controllers/theme_store.dart';
import 'modules/splash/splash_module.dart';
import 'shared/database/database.dart';
import 'app_core.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    AsyncBind<AppDatabase>(
      (i) => $FloorAppDatabase.databaseBuilder('app_database.db').build(),
    ),
    Bind.lazySingleton<AppCore>((i) => AppCore()),
    Bind.singleton<ThemeStore>((i) => ThemeStore()),
    Bind.singleton<FirstBootStore>((i) => FirstBootStore(
          i<AppDatabase>().folderDao,
        )),
    Bind.singleton<SettingStore>((i) => SettingStore(
          i<ThemeStore>(),
          i<FirstBootStore>(),
        )),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(
      Modular.initialRoute,
      module: SplashModule(),
      guards: [AppGuard()],
    ),
    ModuleRoute('/dashboard', module: DashboardModule()),
    ModuleRoute('/auth', module: AuthModule()),
  ];
}
