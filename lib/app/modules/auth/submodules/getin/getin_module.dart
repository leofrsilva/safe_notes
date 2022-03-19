import 'package:flutter_modular/flutter_modular.dart';

import 'presenter/getin_page.dart';

class GetInModule extends Module {
  @override
  List<ModularRoute> get routes =>
      [ChildRoute(Modular.initialRoute, child: (_, __) => const GetInPage())];
}
