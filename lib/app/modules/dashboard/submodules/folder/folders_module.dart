import 'package:flutter_modular/flutter_modular.dart';

import 'presenter/folder_page.dart';

class FolderModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/:folder-id',
          child: (_, args) => FolderPage(
            folderId: args.params['folder-id'] as int,
          ),
        ),
      ];
}
