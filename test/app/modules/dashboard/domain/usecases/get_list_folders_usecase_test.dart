import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:modular_test/modular_test.dart';
import 'package:safe_notes/app/app_module.dart';
import 'package:safe_notes/app/modules/dashboard/domain/errors/get_list_failures.dart';
import 'package:safe_notes/app/modules/dashboard/domain/usecases/get_list_folders_usecase.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';

import '../../../../../mocks/mocks_sqlite.dart';
import '../../../../../stub/folder_model_stub.dart';

void main() {
  final repository = GetListRepositoryMock();

  setUpAll(() {
    initModule(AppModule());
  });

  test(
      'get list folders usecase GetListFoldersUsecase.Call | retorna uma Stream de Lista de FolderModel',
      () {
    when(() => repository.getFolders()).thenAnswer(
      (_) => Right(Stream.value(listFolders)),
    );

    final usecase = GetListFoldersUsecase(repository);
    final result = usecase.call();

    expect(result.isRight(), equals(true));
    expect(result.fold(id, id), isA<Stream<List<FolderModel>>>());
  });

  test(
      'get list folders usecase GetListFoldersUsecase.Call | retorna GetListFoldersSqliteError',
      () {
    when(() => repository.getFolders())
        .thenReturn(Left(GetListFoldersSqliteErrorMock()));

    final usecase = GetListFoldersUsecase(repository);
    final result = usecase.call();

    expect(result.isLeft(), equals(true));
    expect(result.fold(id, id), isA<GetListFoldersSqliteError>());
  });
}
