import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/add_or_edit_note/domain/errors/add_or_edit_failures.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/add_or_edit_note/domain/usecases/add_note_usecase.dart';

import '../../../../../../../mocks/mocks_sqlite.dart';
import '../../../../../../../stub/note_model_stub.dart';

void main() {
  final note = note1;
  final repository = NoteRepositoryMock();

  test('add note usecase AddNoteUsecase.Call | isRight igual a True', () async {
    when(() => repository.addNote(note)).thenAnswer(
      (_) async => const Right(dynamic),
    );

    final usecase = AddNoteUsecase(repository);
    final result = await usecase.call(note);

    expect(result.isRight(), equals(true));
  });

  test('add note usecase AddNoteUsecase.Call | retorna AddNoteSqliteError',
      () async {
    when(() => repository.addNote(note)).thenAnswer(
      (_) async => Left(AddNoteSqliteErrorMock()),
    );

    final usecase = AddNoteUsecase(repository);
    final result = await usecase.call(note);

    expect(result.isLeft(), equals(true));
    expect(result.fold(id, id), isA<AddNoteSqliteError>());
  });

  test(
      'add note usecase AddNoteUsecase.Call | retorna NotReturnNoteIdSqliteError',
      () async {
    when(() => repository.addNote(note)).thenAnswer(
      (_) async => Left(NotReturnNoteIdSqliteError()),
    );

    final usecase = AddNoteUsecase(repository);
    final result = await usecase.call(note);

    expect(result.isLeft(), equals(true));
    expect(result.fold(id, id), isA<NotReturnNoteIdSqliteError>());
  });
}
