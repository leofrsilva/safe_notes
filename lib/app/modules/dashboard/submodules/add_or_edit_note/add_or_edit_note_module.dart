import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/shared/database/database.dart';
import 'domain/repositories/i_note_repository.dart';
import 'domain/usecases/add_note_usecase.dart';
import 'domain/usecases/delete_note_empty_usecase.dart';
import 'domain/usecases/edit_note_usecase.dart';
import 'domain/usecases/i_note_usecases.dart';
import 'external/datasources/note_datasource.dart';
import 'infra/datasources/i_note_datasource.dart';
import 'infra/repositories/note_repository.dart';
import 'presenter/add_or_edit_note_controller.dart';
import 'presenter/add_or_edit_note_page.dart';

class AddOrEditNoteModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.lazySingleton<INoteDatasource>((i) => NoteDatasource(
              i<AppDatabase>().noteDao,
            )),
        Bind.lazySingleton<INoteRepository>((i) => NoteRepository(
              i<INoteDatasource>(),
            )),
        //
        Bind.lazySingleton<IAddNoteUsecase>((i) => AddNoteUsecase(
              i<INoteRepository>(),
            )),
        Bind.lazySingleton<IEditNoteUsecase>((i) => EditNoteUsecase(
              i<INoteRepository>(),
            )),
        Bind.lazySingleton<IDeleteNoteEmptyUsecase>(
            (i) => DeleteNoteEmptyUsecase(
                  i<INoteRepository>(),
                )),
        //
        Bind.lazySingleton<AddOrEditNoteController>(
            (i) => AddOrEditNoteController(
                  i<IAddNoteUsecase>(),
                  i<IEditNoteUsecase>(),
                  i<IDeleteNoteEmptyUsecase>(),
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
      ];
}
