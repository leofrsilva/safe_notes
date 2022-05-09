import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/lixeira/domain/errors/lixeira_failures.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/lixeira/external/datasources/lixeira_datasource.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/lixeira/infra/datasources/i_lixeira_datasource.dart';
import 'package:safe_notes/app/shared/database/daos/folder_dao.dart';
import 'package:safe_notes/app/shared/database/daos/note_dao.dart';
import 'package:safe_notes/app/shared/database/database.dart';
import 'package:safe_notes/app/shared/database/entities/note_entity.dart';

import '../../../../../../../mocks/mocks_sqlite.dart';
import '../../../../../../../stub/folder_model_stub.dart';
import '../../../../../../../stub/note_model_stub.dart';

void main() {
  late AppDatabase database;
  late FolderDAO folderDAO;
  late NoteDAO noteDAO;
  late ILixeiraDatasource datasource;

  setUpAll(() async {
    database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
    folderDAO = database.folderDao;
    noteDAO = database.noteDao;
    datasource = LixeiraDatasource(noteDAO);

    for (var folder in listfolder) {
      folderDAO.insertFolder(folder.entity);
    }
  });

  tearDownAll(() async {
    await database.close();
  });

  group('lixeira datasource getNotesDeleted |', () {
    test('Retorna uma Lista de NoteEntity de notes deletadas', () async {
      await folderDAO.updateFolders([
        folder3.copyWith(isDeleted: true).entity,
      ]);
      for (var note in listNote) {
        await noteDAO.insertNote(note.copyWith(isDeleted: true).entity);
      }

      final result = await datasource.getNotesDeleted();

      expect(result.length, equals(1));
      expect(result.first, isA<NoteEntity>());
      expect(result.first.folderId, equals(folder4.folderId));
      expect(result.first.id, equals(note4.noteId));
    });

    test('retorna um GetNotesDeletedSqliteError', () {
      final noteDAOMock = NoteDAOMock();
      final datasouceMock = LixeiraDatasource(noteDAOMock);

      when(() => noteDAOMock.getNotesDeleted())
          .thenThrow(SqliteExceptionMock());

      expect(
        () => datasouceMock.getNotesDeleted(),
        throwsA(isA<GetNotesDeletedSqliteError>()),
      );
    });
  });
}
