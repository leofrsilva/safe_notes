import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/dashboard/domain/errors/folder_failures.dart';
import 'package:safe_notes/app/modules/dashboard/domain/usecases/folder/edit_folder_usecase.dart';

import '../../../../../../mocks/mocks_sqlite.dart';
import '../../../../../../stub/folder_model_stub.dart';

void main() {
  final folder = folder1;
  final repository = FolderRepositoryMock();

  test('edit folder usecase EditFolderUsecase.Call | isRight igual a True',
      () async {
    when(() => repository.editFolder(folder)).thenAnswer(
      (_) async => const Right(dynamic),
    );

    final usecase = EditFolderUsecase(repository);
    final result = await usecase.call(folder);

    expect(result.isRight(), equals(true));
  });

  test(
      'edit folder usecase EditFolderUsecase.Call | retorna EditFolderSqliteError',
      () async {
    when(() => repository.editFolder(folder)).thenAnswer(
      (_) async => Left(EditFolderSqliteErrorMock()),
    );

    final usecase = EditFolderUsecase(repository);
    final result = await usecase.call(folder);

    expect(result.isLeft(), equals(true));
    expect(result.fold(id, id), isA<EditFolderSqliteError>());
  });

  test(
      'edit folder usecase EditFolderUsecase.Call | retorna NoFolderRecordsChangedSqliteError',
      () async {
    when(() => repository.editFolder(folder)).thenAnswer(
      (_) async => Left(NoFolderRecordsChangedSqliteErrorMock()),
    );

    final usecase = EditFolderUsecase(repository);
    final result = await usecase.call(folder);

    expect(result.isLeft(), equals(true));
    expect(result.fold(id, id), isA<NoFolderRecordsChangedSqliteError>());
  });
}
