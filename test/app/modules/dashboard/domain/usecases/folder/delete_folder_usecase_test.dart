import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:modular_test/modular_test.dart';
import 'package:safe_notes/app/app_module.dart';
import 'package:safe_notes/app/modules/dashboard/domain/errors/folder_failures.dart';
import 'package:safe_notes/app/modules/dashboard/domain/usecases/folder/delete_folder_usecase.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/encrypt/encrypt.dart';

import '../../../../../../mocks/mocks_sqlite.dart';
import '../../../../../../stub/folder_model_stub.dart';

void main() {
  late FolderModel folder;
  late DataEncrypt dataEncrypt;
  final repository = FolderRepositoryMock();

  setUpAll(() {
    initModule(AppModule());
    folder = folder1;
    dataEncrypt = DataEncrypt();
    dataEncrypt.setKey('val1');
  });

  test('delete folder usecase DeleteFolderUsecase.Call | isRight igual a True',
      () async {
    when(() => repository.deleteFolder([folder])).thenAnswer(
      (_) async => const Right(dynamic),
    );

    final usecase = DeleteFolderUsecase(repository, dataEncrypt);
    final result = await usecase.call([folder]);

    expect(result.isRight(), equals(true));
  });

  test(
      'delete folder usecase DeleteFolderUsecase.Call | retorna NoFolderEditedToDeletedSqliteError',
      () async {
    when(() => repository.deleteFolder([folder])).thenAnswer(
      (_) async => Left(NoFolderEditedToDeletedSqliteError()),
    );

    final usecase = DeleteFolderUsecase(repository, dataEncrypt);
    final result = await usecase.call([folder]);

    expect(result.isLeft(), equals(true));
    expect(result.fold(id, id), isA<NoFolderEditedToDeletedSqliteError>());
  });

  test(
      'delete folder usecase DeleteFolderUsecase.Call | retorna DeleteFolderSqliteError',
      () async {
    when(() => repository.deleteFolder([folder])).thenAnswer(
      (_) async => Left(DeleteFolderSqliteErrorMock()),
    );

    final usecase = DeleteFolderUsecase(repository, dataEncrypt);
    final result = await usecase.call([folder]);

    expect(result.isLeft(), equals(true));
    expect(result.fold(id, id), isA<DeleteFolderSqliteError>());
  });

  test(
      'delete folder usecase DeleteFolderUsecase.Call | retorna IncorrectEncryptionError',
      () async {
    await dataEncrypt.setKey('val2');
    when(() => repository.deleteFolder([folder])).thenAnswer(
      (_) async => const Right(dynamic),
    );

    final usecase = DeleteFolderUsecase(repository, dataEncrypt);
    final result = await usecase.call([folder]);

    expect(result.isLeft(), equals(true));
    expect(result.fold(id, id), isA<IncorrectEncryptionError>());
  });
}
