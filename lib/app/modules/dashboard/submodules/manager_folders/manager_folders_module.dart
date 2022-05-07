import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/app_core.dart';
import 'package:safe_notes/app/shared/database/database.dart';

import '../../presenter/pages/drawer/drawer_menu_controller.dart';
import 'domain/repositories/i_manager_folders_repository.dart';
import 'domain/usecases/add_folder_usecase.dart';
import 'domain/usecases/delete_folder_usecase.dart';
import 'domain/usecases/edit_folder_usecase.dart';
import 'domain/usecases/i_manager_folders_usecase.dart';
import 'external/datasources/manager_folders_datasource.dart';
import 'infra/datasources/i_manager_folders_datasource.dart';
import 'infra/repositories/manager_folders_repository.dart';
import 'presenter/manager_folders_controller.dart';
import 'presenter/manager_folders_page.dart';

class ManagerFoldersModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.lazySingleton<IManagerFoldersDatasource>(
            (i) => ManagerFoldersDatasource(i<AppDatabase>().folderDao)),
        Bind.lazySingleton<IManagerFoldersRepository>(
            (i) => ManagerFoldersRepository(i<IManagerFoldersDatasource>())),
        //
        Bind.lazySingleton<IAddFolderUsecase>(
            (i) => AddFolderUsecase(i<IManagerFoldersRepository>())),
        Bind.lazySingleton<IEditFolderUsecase>(
            (i) => EditFolderUsecase(i<IManagerFoldersRepository>())),
        Bind.lazySingleton<IDeleteFolderUsecase>(
            (i) => DeleteFolderUsecase(i<IManagerFoldersRepository>())),
        //
        Bind.lazySingleton<ManagerFoldersController>(
          (i) => ManagerFoldersController(
            i<AppCore>(),
            i<IAddFolderUsecase>(),
            i<IEditFolderUsecase>(),
            i<IDeleteFolderUsecase>(),
            i<DrawerMenuController>(),
          ),
        ),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          Modular.initialRoute,
          child: (_, __) => const ManagerFoldersPage(),
        ),
      ];
}
