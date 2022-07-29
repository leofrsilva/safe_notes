import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/app_core.dart';
import 'package:safe_notes/app/shared/encrypt/data_encrypt.dart';

import 'controllers/setting_controller.dart';
import 'controllers/theme_store.dart';
import 'presenter/setting_page.dart';

class SettingModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.lazySingleton<SettingController>((i) => SettingController(
              i<ThemeStore>(),
              i<AppCore>(),
              i<DataEncrypt>(),
            )),
      ];
  @override
  List<ModularRoute> get routes => [
        ChildRoute(Modular.initialRoute, child: (_, __) => const SettingPage()),
      ];
}
