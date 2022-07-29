import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../domain/usecases/folder/i_folder_usecase.dart';
import '../../domain/usecases/note/i_note_usecases.dart';
import '../../presenter/pages/drawer/drawer_menu_controller.dart';
import 'download/download_controller.dart';
import 'upload/upload_controller.dart';
import 'upload/upload_page.dart';
import 'download/download_page.dart';

class BackupModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.lazySingleton<DownloadController>((i) => DownloadController()),
        Bind.lazySingleton<UploadController>((i) => UploadController(
              i<IAddNoteUsecase>(),
              i<IAddFolderUsecase>(),
              i<IDeleteNotePersistentUsecase>(),
              i<IDeleteFolderPersistentUsecase>(),
              i<DrawerMenuController>(),
            )),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/upload',
          child: (_, __) => const UploadPage(),
          transition: TransitionType.custom,
          customTransition: CustomTransition(
            opaque: false,
            transitionBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        ),
        ChildRoute(
          '/download',
          child: (_, __) => const DownloadPage(),
          transition: TransitionType.custom,
          customTransition: CustomTransition(
            opaque: false,
            transitionBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        ),
      ];
}
