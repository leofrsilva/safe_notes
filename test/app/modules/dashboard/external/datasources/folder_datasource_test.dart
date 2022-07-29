import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:modular_test/modular_test.dart';
import 'package:safe_notes/app/app_module.dart';
import 'package:safe_notes/app/modules/dashboard/domain/errors/folder_failures.dart';
import 'package:safe_notes/app/modules/dashboard/external/datasources/folder_datasource.dart';
import 'package:safe_notes/app/modules/dashboard/infra/datasources/i_folder_datasource.dart';
import 'package:safe_notes/app/shared/database/daos/folder_dao.dart';
import 'package:safe_notes/app/shared/database/daos/note_dao.dart';
import 'package:safe_notes/app/shared/database/database.dart';
import 'package:safe_notes/app/shared/database/entities/folder_entity.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';

import '../../../../../mocks/mocks_sqlite.dart';
import '../../../../../stub/folder_model_stub.dart';
import '../../../../../stub/note_model_stub.dart';

void main() {
  late AppDatabase database;
  late FolderDAO folderDAO;
  late NoteDAO noteDAO;
  late IFolderDatasource datasource;

  setUpAll(() async {
    initModule(AppModule());

    database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
    folderDAO = database.folderDao;
    noteDAO = database.noteDao;
    await folderDAO.insertFolders([folder.entity]);

    datasource = FolderDatasource(folderDAO, noteDAO);
  });

  tearDownAll(() async {
    await database.close();
  });

  group('folder datasource addFolder |', () {
    late FolderEntity folderEntity;
    setUpAll(() => folderEntity = folder4.entity);

    test('Adicionado uma Pasta com Sucesso', () async {
      final result = await datasource.addFolders([folderEntity]);

      expect(result, equals([folderEntity.id]));
    });

    test('retorna um AddFolderSqliteError', () async {
      final folderDAOMock = FolderDAOMock();
      final datasouceMock = FolderDatasource(folderDAOMock, noteDAO);

      when(() => folderDAOMock.insertFolders([folderEntity]))
          .thenThrow(SqliteExceptionMock());

      expect(
        () => datasouceMock.addFolders([folderEntity]),
        throwsA(isA<AddFolderSqliteError>()),
      );
    });

    test('retorna um NotReturnFolderIdSqliteError', () async {
      final folderDAOMock = FolderDAOMock();
      final datasouceMock = FolderDatasource(folderDAOMock, noteDAO);

      when(() => folderDAOMock.insertFolders([folderEntity]))
          .thenAnswer((_) async => []);

      expect(
        () => datasouceMock.addFolders([folderEntity]),
        throwsA(isA<NotReturnFolderIdSqliteError>()),
      );
    });
  });

  group('folder datasource editFolder |', () {
    late FolderModel folderModel;
    setUpAll(() => folderModel = folder2);

    test('Editou a Pasta com Sucesso', () async {
      await folderDAO.insertFolders([folderModel.entity]);

      var folderEdited = folderModel.copyWith(
        color: 222222,
        name: 'Folder Edited',
      );
      final result = await datasource.editFolder(folderEdited);

      expect(result, equals(1));

      var folderResult = await folderDAO.findFolder(folderModel.folderId);
      expect(folderResult, isNotNull);
      expect(folderResult!.name, equals(folderEdited.name));
      expect(folderResult.color, equals(folderEdited.color));
    });

    test('retorna um EditFolderSqliteError', () async {
      final folderDAOMock = FolderDAOExceptionMock();
      final datasouceMock = FolderDatasource(folderDAOMock, noteDAO);

      when(() => folderDAOMock.findFolder(folderModel.folderId))
          .thenAnswer((_) async => folderModel.entity);
      expect(
        () => datasouceMock.editFolder(folderModel),
        throwsA(isA<EditFolderSqliteError>()),
      );

      when(() => folderDAOMock.findFolder(folderModel.folderId))
          .thenThrow(SqliteExceptionMock());
      expect(
        () => datasouceMock.editFolder(folderModel),
        throwsA(isA<EditFolderSqliteError>()),
      );
    });

    test('retorna um NoFolderRecordsChangedSqliteError', () async {
      final folderDAOMock = FolderDAONoUpdateFolderMock();
      final datasouceMock = FolderDatasource(folderDAOMock, noteDAO);

      when(() => folderDAOMock.findFolder(folderModel.folderId))
          .thenAnswer((_) async => folderModel.entity);
      expect(
        () => datasouceMock.editFolder(folderModel),
        throwsA(isA<NoFolderRecordsChangedSqliteError>()),
      );

      when(() => folderDAOMock.findFolder(folderModel.folderId))
          .thenAnswer((_) async => null);
      expect(
        () => datasouceMock.editFolder(folderModel),
        throwsA(isA<NoFolderRecordsChangedSqliteError>()),
      );
    });
  });

  group('folder datasource deleteFolder |', () {
    test('retorna um NoFolderEditedToDeletedSqliteError', () async {
      final note = folder3.entity;
      await folderDAO.insertFolders([note]);

      expect(
        () => datasource.deleteFolder([note]),
        throwsA(isA<NoFolderEditedToDeletedSqliteError>()),
      );
    });

    test('Deletado a Pasta e seus filhos com Sucesso', () async {
      // INSERT FOLDERS
      await folderDAO.insertFolders([folder1.entity]);
      await folderDAO.insertFolders([folder11.entity]);
      await folderDAO.insertFolders([folder111.entity]);
      await folderDAO.insertFolders([folder1111.entity]);

      // INSERT NOTES
      await noteDAO.insertNotes([
        note1.copyWith(folderId: folder1.folderId).entity,
      ]);
      await noteDAO.insertNotes([
        note2.copyWith(folderId: folder1.folderId).entity,
      ]);
      await noteDAO.insertNotes([
        note3.copyWith(folderId: folder11.folderId).entity,
      ]);
      await noteDAO.insertNotes([
        note4.copyWith(folderId: folder111.folderId).entity,
      ]);
      await noteDAO.insertNotes([
        note5.copyWith(folderId: folder1111.folderId).entity,
      ]);

      final folderer = folder1.copyWith(isDeleted: true);
      await datasource.deleteFolder([folderer.entity]);

      var folder = await folderDAO.findFolder(folder1111.folderId);
      expect(folder, isNotNull);
      expect(folder!.isDeleted, equals(1));
      var note = await noteDAO.findNote(note5.noteId); // NOTE 5
      expect(note, isNotNull);
      expect(note!.isDeleted, equals(1));

      folder = await folderDAO.findFolder(folder111.folderId);
      expect(folder, isNotNull);
      expect(folder!.isDeleted, equals(1));
      note = await noteDAO.findNote(note4.noteId); // NOTE 4
      expect(note, isNotNull);
      expect(note!.isDeleted, equals(1));

      folder = await folderDAO.findFolder(folder11.folderId);
      expect(folder, isNotNull);
      expect(folder!.isDeleted, equals(1));
      note = await noteDAO.findNote(note3.noteId); // NOTE 3
      expect(note, isNotNull);
      expect(note!.isDeleted, equals(1));

      folder = await folderDAO.findFolder(folder1.folderId);
      expect(folder, isNotNull);
      expect(folder!.isDeleted, equals(1));
      note = await noteDAO.findNote(note2.noteId); // NOTE 2
      expect(note, isNotNull);
      expect(note!.isDeleted, equals(1));
      note = await noteDAO.findNote(note1.noteId); // NOTE 1
      expect(note, isNotNull);
      expect(note!.isDeleted, equals(1));
    });

    test('retorna um DeleteFolderSqliteError', () async {
      await folderDAO.insertFolders([folder5.entity]);

      final folderDAOMock = FolderDAOExceptionMock();
      final datasouceMock = FolderDatasource(folderDAOMock, noteDAO);

      final folder = folder5.copyWith(isDeleted: true);
      expect(
        () => datasouceMock.deleteFolder([folder.entity]),
        throwsA(isA<DeleteFolderSqliteError>()),
      );
    });
  });

  group('folder datasource restoreFolder |', () {
    test('retorna um NoFolderEditedToRestoredSqliteError', () async {
      var note = folder7.copyWith(isDeleted: true);
      await folderDAO.insertFolders([note.entity]);

      expect(
        () => datasource.restoreFolder([note.entity]),
        throwsA(isA<NoFolderEditedToRestoredSqliteError>()),
      );
    });

    test('Restaurado a Pasta e seus filhos com Sucesso', () async {
      await folderDAO.insertFolders([folder6.copyWith(isDeleted: true).entity]);
      await folderDAO
          .insertFolders([folder61.copyWith(isDeleted: true).entity]);
      await folderDAO
          .insertFolders([folder611.copyWith(isDeleted: true).entity]);
      final folderer = folder6.copyWith(isDeleted: false);

      await datasource.restoreFolder([folderer.entity]);

      var folder = await folderDAO.findFolder(folder611.folderId);
      expect(folder, isNotNull);
      expect(folder!.isDeleted, equals(0));
      folder = await folderDAO.findFolder(folder61.folderId);
      expect(folder, isNotNull);
      expect(folder!.isDeleted, equals(0));
      folder = await folderDAO.findFolder(folder6.folderId);
      expect(folder, isNotNull);
      expect(folder!.isDeleted, equals(0));
    });

    test('retorna um RestoreFolderSqliteError', () async {
      await folderDAO.insertFolders([folder8.entity]);

      final folderDAOMock = FolderDAOExceptionMock();
      final datasouceMock = FolderDatasource(folderDAOMock, noteDAO);

      final folder = folder8.copyWith(isDeleted: false);
      expect(
        () => datasouceMock.restoreFolder([folder.entity]),
        throwsA(isA<RestoreFolderSqliteError>()),
      );
    });
  });

  group('folder datasource deletePersistentFolder |', () {
    test('Restaurado a Pasta e seus filhos com Sucesso', () async {
      await folderDAO.insertFolders([folder9.copyWith(isDeleted: true).entity]);
      await folderDAO
          .insertFolders([folder91.copyWith(isDeleted: true).entity]);

      await datasource.deletePersistentFolder([folder9.entity]);

      var folder = await folderDAO.findFolder(folder91.folderId);
      expect(folder, isNull);
      folder = await folderDAO.findFolder(folder9.folderId);
      expect(folder, isNull);
    });

    test('retorna um DeleteFolderPersistentSqliteError', () async {
      await folderDAO.insertFolders([folder10.entity]);

      final folderDAOMock = FolderDAOExceptionMock();
      final datasouceMock = FolderDatasource(folderDAOMock, noteDAO);

      final folder = folder10.copyWith(isDeleted: false);
      expect(
        () => datasouceMock.deletePersistentFolder([folder.entity]),
        throwsA(isA<DeleteFolderPersistentSqliteError>()),
      );
    });
  });
}
