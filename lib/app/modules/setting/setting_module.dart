import 'package:flutter_modular/flutter_modular.dart';

import 'presenter/setting_page.dart';

class SettingModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute(Modular.initialRoute, child: (_, __) => const SettingPage()),
      ];
}
