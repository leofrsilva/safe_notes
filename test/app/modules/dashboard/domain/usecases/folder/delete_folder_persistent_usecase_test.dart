import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:modular_test/modular_test.dart';
import 'package:safe_notes/app/app_module.dart';
import 'package:safe_notes/app/modules/dashboard/domain/errors/folder_failures.dart';
import 'package:safe_notes/app/modules/dashboard/domain/usecases/folder/delete_folder_persistent_usecase.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';

import '../../../../../../mocks/mocks_sqlite.dart';
import '../../../../../../stub/folder_model_stub.dart';

void main() {
  late FolderModel folder;
  final repository = FolderRepositoryMock();

  setUpAll(() {
    initModule(AppModule());
    folder = folder1;
  });

  test(
      'delete folder persistent usecase DeleteFolderPersistentUsecase.Call | isRight igual a True',
      () async {
    when(() => repository.deletePersistentFolder([folder])).thenAnswer(
      (_) async => const Right(dynamic),
    );

    final usecase = DeleteFolderPersistentUsecase(repository);
    final result = await usecase.call([folder]);

    expect(result.isRight(), equals(true));
  });

  test(
      'delete folder persistent usecase DeleteFolderPersistentUsecase.Call | retorna DeleteFolderPersistentSqliteError',
      () async {
    when(() => repository.deletePersistentFolder([folder])).thenAnswer(
      (_) async => Left(DeleteFolderPersistentSqliteErrorMock()),
    );

    final usecase = DeleteFolderPersistentUsecase(repository);
    final result = await usecase.call([folder]);

    expect(result.isLeft(), equals(true));
    expect(result.fold(id, id), isA<DeleteFolderPersistentSqliteError>());
  });
}
