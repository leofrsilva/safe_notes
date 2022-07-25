import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:modular_test/modular_test.dart';
import 'package:safe_notes/app/app_module.dart';
import 'package:safe_notes/app/modules/dashboard/domain/errors/note_failures.dart';
import 'package:safe_notes/app/modules/dashboard/domain/usecases/note/delete_note_persistent_usecase.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';
import 'package:safe_notes/app/shared/encrypt/encrypt.dart';

import '../../../../../../mocks/mocks_sqlite.dart';
import '../../../../../../stub/note_model_stub.dart';

void main() {
  late NoteModel note = note1;
  late DataEncrypt dataEncrypt;
  final repository = NoteRepositoryMock();

  setUpAll(() {
    initModule(AppModule());
    note = note1;
    dataEncrypt = DataEncrypt();
    dataEncrypt.setKey('val1');
  });

  test(
      'delete note persistent usecase DeleteNotePersistentUsecase.Call | isRight igual a True',
      () async {
    when(() => repository.deletePersistentNote([note])).thenAnswer(
      (_) async => const Right(dynamic),
    );

    final usecase = DeleteNotePersistentUsecase(repository, dataEncrypt);
    final result = await usecase.call([note]);

    expect(result.isRight(), equals(true));
  });

  test(
      'delete note persistent usecase DeleteNotePersistentUsecase.Call | retorna DeleteNotePersistentSqliteError',
      () async {
    when(() => repository.deletePersistentNote([note])).thenAnswer(
      (_) async => Left(DeleteNotePersistentSqliteErrorMock()),
    );

    final usecase = DeleteNotePersistentUsecase(repository, dataEncrypt);
    final result = await usecase.call([note]);

    expect(result.isLeft(), equals(true));
    expect(result.fold(id, id), isA<DeleteNotePersistentSqliteError>());
  });

  test(
      'delete note persistent usecase DeleteNotePersistentUsecase.Call | retorna IncorrectEncryptionError',
      () async {
    await dataEncrypt.setKey('val2');
    when(() => repository.deletePersistentNote([note])).thenAnswer(
      (_) async => const Right(dynamic),
    );

    final usecase = DeleteNotePersistentUsecase(repository, dataEncrypt);
    final result = await usecase.call([note]);

    expect(result.isLeft(), equals(true));
    expect(result.fold(id, id), isA<IncorrectEncryptionError>());
  });
}
