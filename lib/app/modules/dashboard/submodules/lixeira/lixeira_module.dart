import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/shared/database/database.dart';

import 'domain/repositories/i_lixeira_repository.dart';
import 'domain/usecases/get_notes_deleted_usecase.dart';
import 'domain/usecases/i_lixeira_usecases.dart';
import 'external/datasources/lixeira_datasource.dart';
import 'infra/datasources/i_lixeira_datasource.dart';
import 'infra/repositories/lixeira_repository.dart';
import 'presenter/lixeira_controller.dart';
import 'presenter/lixeira_page.dart';

class LixeiraModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.lazySingleton<ILixeiraDatasource>(
          (i) => LixeiraDatasource(
            i<AppDatabase>().noteDao,
          ),
        ),
        Bind.lazySingleton<ILixeiraRepository>(
          (i) => LixeiraRepository(i<ILixeiraDatasource>()),
        ),
        //
        Bind.lazySingleton<IGetNotesDeletedUsecase>(
          (i) => GetNotesDeletedUsecase(i<ILixeiraRepository>()),
        ),
        //
        Bind.lazySingleton((i) => LixeiraController(
              i<IGetNotesDeletedUsecase>(),
            )),
      ];
  @override
  List<ModularRoute> get routes => [
        ChildRoute(Modular.initialRoute, child: (_, __) => const LixeiraPage()),
      ];
}
