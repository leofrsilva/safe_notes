import 'package:flutter_modular/flutter_modular.dart';

import '../../domain/usecases/note/i_note_usecases.dart';
import 'presenter/notes_controller.dart';
import 'presenter/notes_page.dart';
import '../../presenter/stores/selection_store.dart';

class NotesModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.lazySingleton<SelectionStore>((i) => SelectionStore()),
        Bind.lazySingleton<NotesController>(
          (i) => NotesController(
            i<SelectionStore>(),
            i<IEditNoteUsecase>(),
            i<IDeleteNoteUsecase>(),
          ),
        ),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(Modular.initialRoute, child: (_, __) => const NotesPage()),
        ChildRoute(Modular.initialRoute, child: (_, __) => const NotesPage()),
      ];
}
