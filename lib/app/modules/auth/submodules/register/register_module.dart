import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/app_core.dart';
import 'package:safe_notes/app/shared/token/expire_token.dart';

import 'domain/repositories/i_signup_firebase_repository.dart';
import 'domain/usecases/create_authentication_usecase.dart';
import 'domain/usecases/i_signup_firebase_usecase.dart';
import 'domain/usecases/set_user_firestore_usecase.dart';
import 'external/datasources/signup_firebase_datasource.dart';
import 'infra/datasources/i_signup_firebase_datasource.dart';
import 'infra/repositories/signup_firebase_repository.dart';
import 'presenter/adicionar_user_page.dart';
import 'presenter/adicionar_user_store.dart';

class RegisterModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.lazySingleton<ISignupFirebaseDatasource>(
            (i) => SignupFirebaseDatasource(
                  FirebaseAuth.instance,
                  FirebaseFirestore.instance,
                )),
        Bind.lazySingleton<ISignupFirebaseRepository>(
            (i) => SignupFirebaseRepository(
                  i<ISignupFirebaseDatasource>(),
                )),
        //
        Bind.lazySingleton<ICreateUserAuthenticationUsecase>(
          (i) =>
              CreateUserAuthenticationUsecase(i<ISignupFirebaseRepository>()),
        ),
        Bind.lazySingleton<ISetUserFirestoreUsecase>(
          (i) => SetUserFirestoreUsecase(i<ISignupFirebaseRepository>()),
        ),
        //
        Bind.lazySingleton<AdicionarUserController>(
            (i) => AdicionarUserController(
                  i<AppCore>(),
                  ExpireToken(),
                  i<ICreateUserAuthenticationUsecase>(),
                  i<ISetUserFirestoreUsecase>(),
                )),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          Modular.initialRoute,
          child: (_, __) => const AdicionarUserPage(),
        ),
      ];
}
