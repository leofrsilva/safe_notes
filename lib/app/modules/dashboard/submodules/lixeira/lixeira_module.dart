import 'package:flutter_modular/flutter_modular.dart';

import 'presenter/lixeira_page.dart';

class LixeiraModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute(Modular.initialRoute, child: (_, __) => const LixeiraPage()),
      ];
}
