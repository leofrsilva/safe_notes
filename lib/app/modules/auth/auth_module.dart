import 'package:flutter_modular/flutter_modular.dart';

import 'presenter/auth_page.dart';
import 'submodules/getin/getin_module.dart';
import 'submodules/register/register_module.dart';

class AuthModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          Modular.initialRoute,
          child: (_, __) => const AuthPage(),
          children: [
            ModuleRoute(
              '/getin',
              module: GetInModule(),
              transition: TransitionType.leftToRight,
            ),
            ModuleRoute(
              '/register',
              module: RegisterModule(),
              transition: TransitionType.leftToRight,
            ),
          ],
        ),
      ];
}
