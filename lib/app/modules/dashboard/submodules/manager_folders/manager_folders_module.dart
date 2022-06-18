import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/app_core.dart';
import 'package:safe_notes/app/shared/database/database.dart';

import '../../domain/usecases/folder/i_folder_usecase.dart';
import '../../presenter/pages/drawer/drawer_menu_controller.dart';
import 'presenter/manager_folders_controller.dart';
import 'presenter/manager_folders_page.dart';

class ManagerFoldersModule extends Module {
  @override
  List<Bind<Object>> get binds => [
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
