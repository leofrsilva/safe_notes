import 'package:flutter_modular/flutter_modular.dart';

import 'presenter/controllers/setting_controller.dart';
import 'presenter/controllers/theme_store.dart';
import 'presenter/setting_page.dart';

class SettingModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.lazySingleton<SettingController>((i) => SettingController(
              i<ThemeStore>(),
            )),
      ];
  @override
  List<ModularRoute> get routes => [
        ChildRoute(Modular.initialRoute, child: (_, __) => const SettingPage()),
      ];
}
