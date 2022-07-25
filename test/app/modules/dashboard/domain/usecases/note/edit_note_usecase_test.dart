import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:modular_test/modular_test.dart';
import 'package:safe_notes/app/app_module.dart';
import 'package:safe_notes/app/modules/dashboard/domain/errors/note_failures.dart';
import 'package:safe_notes/app/modules/dashboard/domain/usecases/note/edit_note_usecase.dart';
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

  test('edit note usecase EditNoteUsecase.Call | isRight igual a True',
      () async {
    when(() => repository.editNote([note])).thenAnswer(
      (_) async => const Right(dynamic),
    );

    final usecase = EditNoteUsecase(repository, dataEncrypt);
    final result = await usecase.call([note]);

    expect(result.isRight(), equals(true));
  });

  test('edit note usecase EditNoteUsecase.Call | retorna EditNoteSqliteError',
      () async {
    when(() => repository.editNote([note])).thenAnswer(
      (_) async => Left(EditNoteSqliteErrorMock()),
    );

    final usecase = EditNoteUsecase(repository, dataEncrypt);
    final result = await usecase.call([note]);

    expect(result.isLeft(), equals(true));
    expect(result.fold(id, id), isA<EditNoteSqliteError>());
  });

  test(
      'edit note usecase EditNoteUsecase.Call | retorna NoNoteRecordsChangedSqliteError',
      () async {
    when(() => repository.editNote([note])).thenAnswer(
      (_) async => Left(NoNoteRecordsChangedSqliteError()),
    );

    final usecase = EditNoteUsecase(repository, dataEncrypt);
    final result = await usecase.call([note]);

    expect(result.isLeft(), equals(true));
    expect(result.fold(id, id), isA<NoNoteRecordsChangedSqliteError>());
  });

  test(
      'edit note usecase EditNoteUsecase.Call | retorna IncorrectEncryptionError',
      () async {
    await dataEncrypt.setKey('val2');
    when(() => repository.editNote([note])).thenAnswer(
      (_) async => const Right(dynamic),
    );

    final usecase = EditNoteUsecase(repository, dataEncrypt);
    final result = await usecase.call([note]);

    expect(result.isLeft(), equals(true));
    expect(result.fold(id, id), isA<IncorrectEncryptionError>());
  });
}
