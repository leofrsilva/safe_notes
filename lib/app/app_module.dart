import 'package:flutter_modular/flutter_modular.dart';
import 'app_guard.dart';
import 'modules/auth/auth_module.dart';
import 'modules/dashboard/dashboard_module.dart';
import 'modules/setting/controllers/access_boot_store.dart';
import 'modules/setting/controllers/folder_buffer_expanded_store.dart';
import 'modules/setting/controllers/manager_route_navigator_store.dart';
import 'modules/setting/controllers/setting_controller.dart';
import 'modules/setting/controllers/theme_store.dart';
import 'modules/setting/setting_module.dart';
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
    //
    Bind.lazySingleton<ManagerRouteNavigatorStore>(
      (i) => ManagerRouteNavigatorStore(),
    ),
    Bind.lazySingleton<FolderBufferExpandedStore>(
      (i) => FolderBufferExpandedStore(),
    ),
    Bind.lazySingleton<AccessBootStore>(
      (i) => AccessBootStore(i<AppDatabase>().folderDao),
    ),
    Bind.singleton<ThemeStore>((i) => ThemeStore()),
    Bind.singleton<SettingController>((i) => SettingController(
          i<ThemeStore>(),
        )),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(
      Modular.initialRoute,
      module: SplashModule(),
      guards: [AppGuard()],
    ),
    ModuleRoute('/auth', module: AuthModule()),
    ModuleRoute('/dashboard', module: DashboardModule()),
    ModuleRoute('/setting', module: SettingModule()),
  ];
}
