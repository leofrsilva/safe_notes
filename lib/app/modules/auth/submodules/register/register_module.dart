import 'package:flutter_modular/flutter_modular.dart';

import 'presenter/accounts_page.dart';
import 'presenter/pages/register_page.dart';

class RegisterModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute(Modular.initialRoute,
            child: (_, __) => const AccountsPage()),
        ChildRoute('/include', child: (_, __) => const RegisterPage()),
      ];
}
