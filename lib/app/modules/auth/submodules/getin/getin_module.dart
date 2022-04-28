import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/app_core.dart';
import 'package:safe_notes/app/shared/database/database.dart';
import 'package:safe_notes/app/shared/token/expire_token.dart';

import 'domain/repositories/i_getin_firebase_repository.dart';
import 'domain/repositories/i_set_folder_repository.dart';
import 'domain/usecases/external/get_user_firestore_usecase.dart';
import 'domain/usecases/external/i_getin_firebase_usecase.dart';
import 'domain/usecases/external/login_authentication_usecase.dart';
import 'domain/usecases/external/update_logged_user_firestore_usecase.dart';
import 'external/datasources/getin_firebase_datasource.dart';
import 'external/datasources/set_folder_datasource.dart';
import 'infra/datasources/i_getin_firebase_datasource.dart';
import 'infra/datasources/i_set_folder_datasource.dart';
import 'infra/repositories/getin_firebase_repository.dart';
import 'infra/repositories/set_folder_repository.dart';
import 'presenter/pages/getin_controller.dart';
import 'presenter/pages/getin_page.dart';

class GetInModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        //? SetFolder
        Bind.lazySingleton<ISetFolderDatasource>((i) => SetFolderDatasource(
              i<AppDatabase>().folderDao,
            )),
        Bind.lazySingleton<ISetFolderRepository>((i) => SetFolderRepository(
              i<ISetFolderDatasource>(),
            )),
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
        //?
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
        //
        Bind.lazySingleton<GetinController>((i) => GetinController(
              i<AppCore>(),
              ExpireToken(),
              i<ILoginAuthenticationUsecase>(),
              i<IUpdateLoggedUserFirestoreUsecase>(),
              i<IGetUserFirestoreUsecase>(),
            )),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          Modular.initialRoute,
          child: (_, __) => const GetInPage(),
        ),
      ];
}
