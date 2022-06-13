import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/dashboard/domain/errors/folder_failures.dart';
import 'package:safe_notes/app/modules/dashboard/infra/repositories/get_list_repository.dart';
import 'package:safe_notes/app/shared/database/entities/folder_entity.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';

import '../../../../../mocks/mocks_sqlite.dart';
import '../../../../../stub/note_model_stub.dart';
import '../../../../../stub/folder_model_stub.dart';

void main() {
  final datasource = GetListDatasourceMock();

  group('get list repository getFolders | ', () {
    test('retorna uma Stream de Lista de FolderModel', () async {
      when(() => datasource.getFolders()).thenAnswer(
        (_) => Stream.value(
          listFolders.map<FolderEntity>((folder) => folder.entity).toList(),
        ),
      );

      final repository = GetListRepository(datasource);
      final result = repository.getFolders();

      expect(result.isRight(), equals(true));
      expect(result.fold(id, id), isA<Stream<List<FolderModel>>>());
    });

    test('retornar um GetListFoldersSqliteError', () {
      when(() => datasource.getFolders())
          .thenThrow(GetListFoldersSqliteErrorMock());

      final repository = GetListRepository(datasource);
      final result = repository.getFolders();

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<GetListFoldersSqliteError>());
    });
  });

  group('get list repository getNotes | ', () {
    test('retorna uma Stream de Lista de NoteModel', () async {
      when(() => datasource.getNotes()).thenAnswer((_) => Stream.value(
            listNotes.map((note) => note.entity).toList(),
          ));

      final repository = GetListRepository(datasource);
      final result = repository.getNotes();

      expect(result.isRight(), equals(true));
      expect(result.fold(id, id), isA<Stream<List<NoteModel>>>());
    });

    test('retornar um GetListNotesSqliteError', () {
      when(() => datasource.getNotes())
          .thenThrow(GetListNotesSqliteErrorMock());

      final repository = GetListRepository(datasource);
      final result = repository.getNotes();

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<GetListNotesSqliteError>());
    });
  });
}
