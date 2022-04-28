import 'package:flutter_modular/flutter_modular.dart';

import 'presenter/folders_page.dart';

class FoldersModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute(Modular.initialRoute, child: (_, __) => const FoldersPage()),
      ];
}
