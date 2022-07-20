import 'package:flutter_modular/flutter_modular.dart';

import '../../domain/usecases/folder/i_folder_usecase.dart';
import '../../domain/usecases/note/i_note_usecases.dart';
import '../../presenter/stores/list_fields_store.dart';
import '../../presenter/stores/selection_store.dart';
import 'presenter/lixeira_controller.dart';
import 'presenter/lixeira_page.dart';

class LixeiraModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.lazySingleton<SelectionStore>((i) => SelectionStore()),
        Bind.lazySingleton((i) => LixeiraController(
              i<SelectionStore>(),
              i<ListFieldsStore>(),
              i<IRestoreNoteUsecase>(),
              i<IRestoreFolderUsecase>(),
              i<IDeleteNotePersistentUsecase>(),
              i<IDeleteFolderPersistentUsecase>(),
            )),
      ];
  @override
  List<ModularRoute> get routes => [
        ChildRoute(Modular.initialRoute, child: (_, __) => const LixeiraPage()),
      ];
}
