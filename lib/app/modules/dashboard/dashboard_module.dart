import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/app_core.dart';
import 'package:safe_notes/app/modules/setting/controllers/folder_buffer_expanded_store.dart';
import 'package:safe_notes/app/modules/setting/controllers/manager_route_navigator_store.dart';
import 'package:safe_notes/app/shared/database/database.dart';
import 'package:safe_notes/app/shared/encrypt/data_encrypt.dart';
import 'package:safe_notes/app/shared/token/expire_token.dart';

import 'package:safe_notes/app/shared/leave/leave.dart';

import 'domain/repositories/i_folder_repository.dart';
import 'domain/repositories/i_get_list_repository.dart';
import 'domain/repositories/i_note_repository.dart';
import 'domain/usecases/folder/add_folder_usecase.dart';
import 'domain/usecases/folder/delete_folder_persistent_usecase.dart';
import 'domain/usecases/folder/delete_folder_usecase.dart';
import 'domain/usecases/folder/edit_folder_usecase.dart';
import 'domain/usecases/folder/i_folder_usecase.dart';
import 'domain/usecases/folder/restore_folder_usecase.dart';
import 'domain/usecases/get_list_folders_usecase.dart';
import 'domain/usecases/get_list_notes_usecase.dart';
import 'domain/usecases/i_get_list_usecase.dart';
import 'domain/usecases/note/add_note_usecase.dart';
import 'domain/usecases/note/delete_note_persistent_usecase.dart';
import 'domain/usecases/note/delete_note_usecase.dart';
import 'domain/usecases/note/edit_note_usecase.dart';
import 'domain/usecases/note/i_note_usecases.dart';
import 'domain/usecases/note/restore_note_usecase.dart';
import 'external/datasources/folder_datasource.dart';
import 'external/datasources/get_list_datasource.dart';
import 'external/datasources/note_datasource.dart';
import 'infra/datasources/i_folder_datasource.dart';
import 'infra/datasources/i_get_list_datasource.dart';
import 'infra/datasources/i_note_datasource.dart';
import 'infra/repositories/folder_repository.dart';
import 'infra/repositories/get_list_repository.dart';
import 'infra/repositories/note_repository.dart';
import 'presenter/pages/drawer/drawer_menu_controller.dart';
import 'presenter/dashboard_controller.dart';
import 'presenter/dashboard_page.dart';
import 'presenter/stores/list_fields_store.dart';
import 'presenter/stores/list_folders_store.dart';
import 'presenter/stores/list_notes_store.dart';
import 'submodules/add_or_edit_note/add_or_edit_note_module.dart';
import 'submodules/backup/backup_module.dart';
import 'submodules/folder/folder_module.dart';
import 'submodules/manager_folders/manager_folders_module.dart';
import 'submodules/favorites/favorites_module.dart';
import 'submodules/lixeira/lixeira_module.dart';
import 'submodules/notes/notes_module.dart';
import 'submodules/register_key/redister_key_module.dart';

class DashboardModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        //? FOLDER
        Bind.lazySingleton<IFolderDatasource>((i) => FolderDatasource(
              i<AppDatabase>().folderDao,
              i<AppDatabase>().noteDao,
            )),
        Bind.lazySingleton<IFolderRepository>(
            (i) => FolderRepository(i<IFolderDatasource>())),
        //
        Bind.lazySingleton<IAddFolderUsecase>((i) => AddFolderUsecase(
              i<IFolderRepository>(),
              i<DataEncrypt>(),
            )),
        Bind.lazySingleton<IEditFolderUsecase>((i) => EditFolderUsecase(
              i<IFolderRepository>(),
              i<DataEncrypt>(),
            )),
        Bind.lazySingleton<IDeleteFolderUsecase>((i) => DeleteFolderUsecase(
              i<IFolderRepository>(),
              i<DataEncrypt>(),
            )),
        Bind.lazySingleton<IRestoreFolderUsecase>((i) => RestoreFolderUsecase(
              i<IFolderRepository>(),
              i<DataEncrypt>(),
            )),
        Bind.lazySingleton<IDeleteFolderPersistentUsecase>(
            (i) => DeleteFolderPersistentUsecase(
                  i<IFolderRepository>(),
                  i<DataEncrypt>(),
                )),
        //?
        //? NOTE
        Bind.lazySingleton<INoteDatasource>((i) => NoteDatasource(
              i<AppDatabase>().noteDao,
            )),
        Bind.lazySingleton<INoteRepository>((i) => NoteRepository(
              i<INoteDatasource>(),
            )),
        //
        Bind.lazySingleton<IAddNoteUsecase>((i) => AddNoteUsecase(
              i<INoteRepository>(),
              i<DataEncrypt>(),
            )),
        Bind.lazySingleton<IEditNoteUsecase>((i) => EditNoteUsecase(
              i<INoteRepository>(),
              i<DataEncrypt>(),
            )),
        Bind.lazySingleton<IRestoreNoteUsecase>((i) => RestoreNoteUsecase(
              i<INoteRepository>(),
              i<DataEncrypt>(),
            )),
        Bind.lazySingleton<IDeleteNoteUsecase>((i) => DeleteNoteUsecase(
              i<INoteRepository>(),
              i<DataEncrypt>(),
            )),
        Bind.lazySingleton<IDeleteNotePersistentUsecase>(
            (i) => DeleteNotePersistentUsecase(
                  i<INoteRepository>(),
                  i<DataEncrypt>(),
                )),
        //?
        //? GET LIST
        Bind.lazySingleton<IGetListDatasource>((i) => GetListDatasource(
              i<AppDatabase>().folderDao,
              i<AppDatabase>().noteDao,
            )),
        Bind.lazySingleton<IGetListRepository>((i) => GetListRepository(
              i<IGetListDatasource>(),
            )),
        Bind.lazySingleton<IGetListFoldersUsecase>((i) => GetListFoldersUsecase(
              i<IGetListRepository>(),
            )),
        Bind.lazySingleton<IGetListNotesUsecase>((i) => GetListNotesUsecase(
              i<IGetListRepository>(),
            )),
        //?
        //? LEAVE
        Bind.lazySingleton<ILeaveDatasource>(
          (i) => LeaveDatasource(
            FirebaseAuth.instance,
            FirebaseFirestore.instance,
          ),
        ),
        Bind.lazySingleton<ILeaveRepository>(
          (i) => LeaveRepository(i<ILeaveDatasource>()),
        ),
        Bind.lazySingleton<ILeaveAuthUsecase>(
          (i) => LeaveAuthUsecase(i<ILeaveRepository>()),
        ),
        //?
        //?
        Bind.singleton<ListNotesStore>(
          (i) => ListNotesStore(i<IGetListNotesUsecase>()),
        ),
        Bind.singleton<ListFoldersStore>(
          (i) => ListFoldersStore(i<IGetListFoldersUsecase>()),
        ),
        Bind.singleton<ListFieldsStore>(
          (i) => ListFieldsStore(
            i<ListNotesStore>(),
            i<ListFoldersStore>(),
            i<FolderBufferExpandedStore>(),
          ),
        ),
        //
        Bind.lazySingleton<DashboardController>((i) => DashboardController(
              i<AppCore>(),
              ExpireToken(),
              i<ILeaveAuthUsecase>(),
              i<ListFieldsStore>(),
              i<IDeleteNotePersistentUsecase>(),
              i<IDeleteFolderPersistentUsecase>(),
            )),
        //
        Bind.singleton((i) => DrawerMenuController(
              i<ListFieldsStore>(),
              i<ManagerRouteNavigatorStore>(),
            )),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          Modular.initialRoute,
          child: (_, __) => const DashboardPage(),
          children: [
            ModuleRoute(
              '/mod-notes',
              module: NotesModule(),
              transition: TransitionType.rightToLeft,
            ),
            ModuleRoute(
              '/mod-favorites',
              module: FavoritesModule(),
              transition: TransitionType.rightToLeft,
            ),
            ModuleRoute(
              '/mod-lixeira',
              module: LixeiraModule(),
              transition: TransitionType.rightToLeft,
            ),
            ModuleRoute(
              '/mod-folder',
              module: FolderModule(),
              transition: TransitionType.rightToLeft,
            ),
          ],
        ),
        // ChildRoute(
        //   '/perfil',
        //   child: (_, __) => const PerfilPage(),
        //   transition: TransitionType.rightToLeft,
        // ),
        ModuleRoute(
          '/manager-folder',
          module: ManagerFoldersModule(),
          transition: TransitionType.rightToLeft,
        ),
        ModuleRoute(
          '/add-or-edit-note',
          module: AddOrEditNoteModule(),
          transition: TransitionType.rightToLeft,
        ),
        ModuleRoute(
          '/register-key',
          module: RegisterKeyModule(),
          transition: TransitionType.rightToLeft,
        ),
        ModuleRoute(
          '/backup',
          module: BackupModule(),
          transition: TransitionType.rightToLeft,
        ),
      ];
}
