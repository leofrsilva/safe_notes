import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/lixeira/domain/errors/lixeira_failures.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/lixeira/infra/repositories/lixeira_repository.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';

import '../../../../../../../mocks/mocks_sqlite.dart';
import '../../../../../../../stub/note_model_stub.dart';

void main() {
  final datasource = LixeiraDatasourceMock();
  group('lixeira repository getNotesDeleted | ', () {
    test('retorna uma Lista de NoteModel', () async {
      when(() => datasource.getNotesDeleted()).thenAnswer(
        (_) async => listNote.map((model) => model.entity).toList(),
      );

      final repository = LixeiraRepository(datasource);
      final result = await repository.getNotesDeleted();

      expect(result.isRight(), equals(true));
      expect(result.fold(id, id), isA<List<NoteModel>>());
      expect(
        (result.fold(id, id) as List<NoteModel>).length,
        equals(4),
      );
    });

    test('retorna um GetNotesDeletedSqliteError', () async {
      when(() => datasource.getNotesDeleted())
          .thenThrow(GetNotesDeletedSqliteErrorMock());

      final repository = LixeiraRepository(datasource);
      final result = await repository.getNotesDeleted();

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<GetNotesDeletedSqliteError>());
    });
  });
}
