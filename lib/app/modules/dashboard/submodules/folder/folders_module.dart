import 'package:flutter_modular/flutter_modular.dart';

import '../../presenter/pages/drawer/drawer_menu_controller.dart';
import 'presenter/folder_controller.dart';
import 'presenter/folder_page.dart';

class FolderModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.singleton<FolderController>((i) => FolderController(
              i<DrawerMenuController>(),
            )),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          Modular.initialRoute,
          child: (_, args) => const FolderPage(),
        ),
      ];
}
