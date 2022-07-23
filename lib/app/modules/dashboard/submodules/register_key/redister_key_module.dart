import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'register_key_page.dart';

class RegisterKeyModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          Modular.initialRoute,
          child: (_, __) => const RegisterKeyPage(),
          transition: TransitionType.custom,
          customTransition: CustomTransition(
            opaque: false,
            transitionBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        ),
      ];
}
