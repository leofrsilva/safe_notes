import 'package:flutter_modular/flutter_modular.dart';

import 'presenter/favorites_page.dart';

class FavoritesModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute(Modular.initialRoute,
            child: (_, __) => const FavoritesPage())
      ];
}
