import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/app_core.dart';
import 'package:safe_notes/app/shared/encrypt/data_encrypt.dart';

import 'domain/repositories/i_save_key_repository.dart';
import 'domain/usecases/save_key_usecase.dart';
import 'external/datasources/save_key_datasource.dart';
import 'infra/datasources/i_save_key_datasource.dart';
import 'infra/repositories/save_key_repository.dart';
import 'presenter/register_key_controller.dart';
import 'presenter/register_key_page.dart';

class RegisterKeyModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.lazySingleton<ISaveKeyDatasource>((i) => SaveKeyDatasource(
              FirebaseFirestore.instance,
            )),
        Bind.lazySingleton<ISaveKeyRepository>((i) => SaveKeyRepository(
              i<ISaveKeyDatasource>(),
            )),
        //
        Bind.lazySingleton<ISaveKeyUsecase>((i) => SaveKeyUsecase(
              i<ISaveKeyRepository>(),
            )),
        //
        Bind.lazySingleton<RegisterKeyController>((i) => RegisterKeyController(
              i<AppCore>(),
              i<DataEncrypt>(),
              i<ISaveKeyUsecase>(),
            )),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          Modular.initialRoute,
          child: (_, __) => const RegisterKeyPage(),
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
