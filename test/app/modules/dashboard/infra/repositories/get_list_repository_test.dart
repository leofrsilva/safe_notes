import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/dashboard/domain/errors/folder_failures.dart';
import 'package:safe_notes/app/modules/dashboard/infra/repositories/get_list_repository.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';
import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';

import '../../../../../mocks/mocks_sqlite.dart';
import '../../../../../stub/folder_qtd_child_view.dart';
import '../../../../../stub/note_model_stub.dart';

void main() {
  final datasource = GetListDatasourceMock();

  group('get list repository getFoldersQtdChild | ', () {
    test('retorna uma Stream de Lista de FolderQtdChildView', () async {
      when(() => datasource.getFoldersQtdChild())
          .thenAnswer((_) => Stream.value(listfolderQtsChild));

      final repository = GetListRepository(datasource);
      final result = repository.getFoldersQtdChild();

      expect(result.isRight(), equals(true));
      expect(result.fold(id, id), isA<Stream<List<FolderQtdChildView>>>());
    });

    test('retornar um GetListFoldersSqliteError', () {
      when(() => datasource.getFoldersQtdChild())
          .thenThrow(GetListFoldersSqliteErrorMock());

      final repository = GetListRepository(datasource);
      final result = repository.getFoldersQtdChild();

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<GetListFoldersSqliteError>());
    });
  });

  group('get list repository getNotes | ', () {
    test('retorna uma Stream de Lista de NoteModel', () async {
      when(() => datasource.getNotes()).thenAnswer((_) => Stream.value(
            listNote.map((note) => note.entity).toList(),
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
