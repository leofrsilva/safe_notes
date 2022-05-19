import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/add_or_edit_note/domain/errors/add_or_edit_failures.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/add_or_edit_note/domain/usecases/edit_note_usecase.dart';

import '../../../../../../../mocks/mocks_sqlite.dart';
import '../../../../../../../stub/note_model_stub.dart';

void main() {
  final note = note1;
  final repository = NoteRepositoryMock();

  test('edit note usecase EditNoteUsecase.Call | isRight igual a True',
      () async {
    when(() => repository.editNote(note)).thenAnswer(
      (_) async => const Right(dynamic),
    );

    final usecase = EditNoteUsecase(repository);
    final result = await usecase.call(note);

    expect(result.isRight(), equals(true));
  });

  test('edit note usecase EditNoteUsecase.Call | retorna EditNoteSqliteError',
      () async {
    when(() => repository.editNote(note)).thenAnswer(
      (_) async => Left(EditNoteSqliteErrorMock()),
    );

    final usecase = EditNoteUsecase(repository);
    final result = await usecase.call(note);

    expect(result.isLeft(), equals(true));
    expect(result.fold(id, id), isA<EditNoteSqliteError>());
  });

  test(
      'edit note usecase EditNoteUsecase.Call | retorna NoNoteRecordsChangedSqliteError',
      () async {
    when(() => repository.editNote(note)).thenAnswer(
      (_) async => Left(NoNoteRecordsChangedSqliteError()),
    );

    final usecase = EditNoteUsecase(repository);
    final result = await usecase.call(note);

    expect(result.isLeft(), equals(true));
    expect(result.fold(id, id), isA<NoNoteRecordsChangedSqliteError>());
  });
}
