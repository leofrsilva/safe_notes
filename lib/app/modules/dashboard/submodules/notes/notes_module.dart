import 'package:flutter_modular/flutter_modular.dart';

import 'presenter/notes_page.dart';

class NotesModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute(Modular.initialRoute, child: (_, __) => const NotesPage()),
      ];
}
