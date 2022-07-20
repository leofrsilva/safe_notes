import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/app_core.dart';
import 'package:safe_notes/app/modules/setting/controllers/access_boot_store.dart';
import 'package:safe_notes/app/shared/database/database.dart';
import 'package:safe_notes/app/shared/token/expire_token.dart';

import 'domain/repositories/i_delete_folder_repository.dart';
import 'domain/repositories/i_getin_firebase_repository.dart';
import 'domain/usecases/external/get_user_firestore_usecase.dart';
import 'domain/usecases/external/i_getin_firebase_usecase.dart';
import 'domain/usecases/external/login_authentication_usecase.dart';
import 'domain/usecases/external/update_logged_user_firestore_usecase.dart';
import 'domain/usecases/sqlite/delete_all_folder_except_usecase.dart';
import 'domain/usecases/sqlite/i_delete_all_folder_except_usecase.dart';
import 'external/datasources/delete_folder_datasource.dart';
import 'external/datasources/getin_firebase_datasource.dart';
import 'infra/datasources/i_delete_folder_datasource.dart';
import 'infra/datasources/i_getin_firebase_datasource.dart';
import 'infra/repositories/delete_folder_repository.dart';
import 'infra/repositories/getin_firebase_repository.dart';
import 'presenter/controllers/login_controller.dart';
import 'presenter/pages/getin/getin_controller.dart';
import 'presenter/pages/getin/getin_page.dart';
import 'presenter/pages/relogar/relogar_controller.dart';
import 'presenter/pages/relogar/relogar_page.dart';

class GetInModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        //? DeleteFolder
        Bind.lazySingleton<IDeleteFolderDatasource>(
            (i) => DeleteFolderDatasource(
                  i<AppDatabase>().folderDao,
                )),
        Bind.lazySingleton<IDeleteFolderRepository>(
            (i) => DeleteFolderRepository(
                  i<IDeleteFolderDatasource>(),
                )),
        //
        Bind.lazySingleton<IDeleteAllFolderExceptUsecase>(
          (i) => DeleteAllFolderExceptUsecase(i<IDeleteFolderRepository>()),
        ),
        //? GetinFirebase
        Bind.lazySingleton<IGetinFirebaseDatasource>(
            (i) => GetinFirebaseDatasource(
                  FirebaseAuth.instance,
                  FirebaseFirestore.instance,
                )),
        Bind.lazySingleton<IGetinFirebaseRepository>(
            (i) => GetinFirebaseRepository(
                  i<IGetinFirebaseDatasource>(),
                )),
        //
        Bind.lazySingleton<ILoginAuthenticationUsecase>(
          (i) => LoginAuthenticationUsecase(i<IGetinFirebaseRepository>()),
        ),
        Bind.lazySingleton<IUpdateLoggedUserFirestoreUsecase>(
          (i) =>
              UpdateLoggedUserFirestoreUsecase(i<IGetinFirebaseRepository>()),
        ),
        Bind.lazySingleton<IGetUserFirestoreUsecase>(
          (i) => GetUserFirestoreUsecase(i<IGetinFirebaseRepository>()),
        ),
        ////
        ////
        Bind.lazySingleton<LoginController>((i) => LoginController(
              i<AppCore>(),
              ExpireToken(),
              i<AccessBootStore>(),
              i<ILoginAuthenticationUsecase>(),
              i<IUpdateLoggedUserFirestoreUsecase>(),
              i<IGetUserFirestoreUsecase>(),
            )),
        Bind.lazySingleton<RelogarController>((i) => RelogarController(
              ExpireToken(),
              i<LoginController>(),
              i<IDeleteAllFolderExceptUsecase>(),
            )),
        Bind.lazySingleton<GetinController>((i) => GetinController(
              i<LoginController>(),
            )),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          Modular.initialRoute,
          child: (_, __) => const GetInPage(),
          transition: TransitionType.leftToRight,
        ),
        ChildRoute(
          '/relogar',
          child: (_, __) => const RelogarPage(),
        ),
      ];
}
