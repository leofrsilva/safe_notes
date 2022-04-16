import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'domain/repositories/i_getin_firebase_repository.dart';
import 'domain/usecases/get_user_firestore_usecase.dart';
import 'domain/usecases/i_getin_firebase_usecase.dart';
import 'domain/usecases/login_authentication_usecase.dart';
import 'external/datasources/getin_firebase_datasource.dart';
import 'infra/datasources/i_getin_firebase_datasource.dart';
import 'infra/repositories/getin_firebase_repository.dart';
import 'presenter/pages/getin_controller.dart';
import 'presenter/pages/getin_page.dart';

class GetInModule extends Module {
  @override
  List<Bind<Object>> get binds => [
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
        Bind.lazySingleton<IGetUserFirestoreUsecase>(
          (i) => GetUserFirestoreUsecase(i<IGetinFirebaseRepository>()),
        ),
        //
        Bind.lazySingleton<GetinController>((i) => GetinController(
              i<ILoginAuthenticationUsecase>(),
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
