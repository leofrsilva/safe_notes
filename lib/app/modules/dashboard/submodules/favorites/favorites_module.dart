import 'package:flutter_modular/flutter_modular.dart';

import '../../domain/usecases/note/i_note_usecases.dart';
import '../../presenter/stores/selection_store.dart';
import 'favorites_controller.dart';
import 'favorites_page.dart';

class FavoritesModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.lazySingleton<SelectionStore>((i) => SelectionStore()),
        Bind.lazySingleton<FavoritesController>((i) => FavoritesController(
              i<SelectionStore>(),
              i<IEditNoteUsecase>(),
              i<IDeleteNoteUsecase>(),
            )),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(Modular.initialRoute,
            child: (_, __) => const FavoritesPage())
      ];
}
