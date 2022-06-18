import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/dashboard/domain/errors/folder_failures.dart';
import 'package:safe_notes/app/modules/dashboard/domain/usecases/folder/add_folder_usecase.dart';

import '../../../../../../mocks/mocks_sqlite.dart';
import '../../../../../../stub/folder_model_stub.dart';

void main() {
  final folder = folder1;
  final repository = FolderRepositoryMock();

  test('add folder usecase AddFolderUsecase.Call | isRight igual a True',
      () async {
    when(() => repository.addFolder(folder)).thenAnswer(
      (_) async => const Right(dynamic),
    );

    final usecase = AddFolderUsecase(repository);
    final result = await usecase.call(folder);

    expect(result.isRight(), equals(true));
  });

  test(
      'add folder usecase AddFolderUsecase.Call | retorna AddFolderSqliteError',
      () async {
    when(() => repository.addFolder(folder)).thenAnswer(
      (_) async => Left(AddFolderSqliteErrorMock()),
    );

    final usecase = AddFolderUsecase(repository);
    final result = await usecase.call(folder);

    expect(result.isLeft(), equals(true));
    expect(result.fold(id, id), isA<AddFolderSqliteError>());
  });

  test(
      'add folder usecase AddFolderUsecase.Call | retorna NotReturnFolderIdSqliteError',
      () async {
    when(() => repository.addFolder(folder)).thenAnswer(
      (_) async => Left(NotReturnFolderIdSqliteErrorMock()),
    );

    final usecase = AddFolderUsecase(repository);
    final result = await usecase.call(folder);

    expect(result.isLeft(), equals(true));
    expect(result.fold(id, id), isA<NotReturnFolderIdSqliteError>());
  });
}
