import 'package:flutter_modular/flutter_modular.dart';
import '../../domain/usecases/note/i_note_usecases.dart';
import 'presenter/add_or_edit_note_controller.dart';
import 'presenter/add_or_edit_note_page.dart';
import 'presenter/deleted_note_controller.dart';
import 'presenter/deleted_note_page.dart';
import 'presenter/stores/expanded_store.dart';
import 'presenter/stores/input_field_note_store.dart';
import 'presenter/stores/scroll_in_top_store.dart';

class AddOrEditNoteModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.lazySingleton<ExpandedStore>((i) => ExpandedStore()),
        Bind.lazySingleton<ScrollInTopStore>((i) => ScrollInTopStore()),
        Bind.lazySingleton<InputFieldNoteStore>((i) => InputFieldNoteStore()),
        //
        Bind.lazySingleton<AddOrEditNoteController>(
            (i) => AddOrEditNoteController(
                  i<IAddNoteUsecase>(),
                  i<IEditNoteUsecase>(),
                  i<IDeleteNotePersistentUsecase>(),
                  i<InputFieldNoteStore>(),
                  i<ExpandedStore>(),
                  i<ScrollInTopStore>(),
                )),
        //
        Bind.lazySingleton<DeletedNoteController>((i) => DeletedNoteController(
              i<ScrollInTopStore>(),
              i<IRestoreNoteUsecase>(),
              i<IDeleteNotePersistentUsecase>(),
            )),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          Modular.initialRoute,
          child: (_, args) => AddOrEditNotePage(
            mode: args.data[0],
            note: args.data[1],
            folder: args.data[2],
          ),
        ),
        ChildRoute(
          '/deleted',
          child: (_, args) => DeletedNotePage(
            mode: args.data[0],
            note: args.data[1],
          ),
        ),
      ];
}
