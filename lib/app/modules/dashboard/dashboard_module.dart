import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/app_core.dart';
import 'package:safe_notes/app/shared/database/database.dart';
import 'package:safe_notes/app/shared/token/expire_token.dart';

import 'package:safe_notes/app/shared/leave/leave.dart';

import 'domain/repositories/i_folder_repository.dart';
import 'domain/usecases/get_list_folders_usecase.dart';
import 'domain/usecases/i_folder_usecase.dart';
import 'external/datasources/folder_datasource.dart';
import 'infra/datasources/i_folder_datasource.dart';
import 'infra/repositories/folder_repository.dart';
import 'presenter/pages/drawer/drawer_menu_controller.dart';
import 'presenter/dashboard_controller.dart';
import 'presenter/dashboard_page.dart';
import 'presenter/stores/list_folders_store.dart';
import 'submodules/folder/folders_module.dart';
import 'submodules/manager_folders/manager_folders_module.dart';
import 'submodules/favorites/favorites_module.dart';
import 'submodules/lixeira/lixeira_module.dart';
import 'submodules/notes/notes_module.dart';

class DashboardModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        //? FOLDER
        Bind.lazySingleton<IFolderDatasource>((i) => FolderDatasource(
              i<AppDatabase>().folderDao,
            )),
        Bind.lazySingleton<IFolderRepository>((i) => FolderRepository(
              i<IFolderDatasource>(),
            )),
        Bind.lazySingleton<IGetListFoldersUsecase>((i) => GetListFoldersUsecase(
              i<IFolderRepository>(),
            )),

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
        Bind.lazySingleton<DashboardController>((i) => DashboardController(
              i<AppCore>(),
              ExpireToken(),
              i<ILeaveAuthUsecase>(),
            )),
        //
        Bind.singleton<ListFoldersStore>(
          (i) => ListFoldersStore(i<IGetListFoldersUsecase>()),
        ),
        Bind.singleton((i) => DrawerMenuController(
              i<ListFoldersStore>(),
            )),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          Modular.initialRoute,
          child: (_, __) => DashboardPage(),
          children: [
            ModuleRoute(
              '/notes',
              module: NotesModule(),
              transition: TransitionType.rightToLeft,
            ),
            ModuleRoute(
              '/favorites',
              module: FavoritesModule(),
              transition: TransitionType.rightToLeft,
            ),
            ModuleRoute(
              '/lixeira',
              module: LixeiraModule(),
              transition: TransitionType.rightToLeft,
            ),
            ModuleRoute(
              '/folder',
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
      ];
}
