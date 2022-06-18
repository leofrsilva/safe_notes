import 'package:safe_notes/app/modules/dashboard/domain/repositories/i_note_repository.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/dashboard/domain/errors/note_failures.dart';
import 'package:safe_notes/app/modules/dashboard/infra/datasources/i_note_datasource.dart';
import 'package:safe_notes/app/shared/database/entities/note_entity.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/domain/errors/getin_failures.dart';
import 'package:safe_notes/app/modules/dashboard/domain/errors/folder_failures.dart';
import 'package:safe_notes/app/modules/dashboard/domain/repositories/i_folder_repository.dart';
import 'package:safe_notes/app/modules/dashboard/infra/datasources/i_folder_datasource.dart';
import 'package:safe_notes/app/shared/database/daos/note_dao.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/domain/repositories/i_delete_folder_repository.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/infra/datasources/i_delete_folder_datasource.dart';
import 'package:safe_notes/app/modules/dashboard/domain/errors/get_list_failures.dart';
import 'package:safe_notes/app/modules/dashboard/domain/repositories/i_get_list_repository.dart';
import 'package:safe_notes/app/modules/dashboard/infra/datasources/i_get_list_datasource.dart';
import 'package:safe_notes/app/shared/database/daos/folder_dao.dart';
import 'package:safe_notes/app/shared/database/entities/folder_entity.dart';

//* Note
class NoteRepositoryMock extends Mock implements INoteRepository {}

class NoteDatasourceMock extends Mock implements INoteDatasource {}

// Failure
class AddNoteSqliteErrorMock extends Mock implements AddNoteSqliteError {}

class EditNoteSqliteErrorMock extends Mock implements EditNoteSqliteError {}

class RestoreNoteSqliteErrorMock extends Mock
    implements RestoreNoteSqliteError {}

class DeleteNoteSqliteErrorMock extends Mock implements DeleteNoteSqliteError {}

class DeleteNotePersistentSqliteErrorMock extends Mock
    implements DeleteNotePersistentSqliteError {}

//* Manager Folder
class FolderDatasourceMock extends Mock implements IFolderDatasource {
  @override
  Future<dynamic> deleteFolder(List<FolderEntity> folders) async {
    return dynamic;
  }

  @override
  Future<dynamic> restoreFolder(List<FolderEntity> folders) async {
    return dynamic;
  }

  @override
  Future<dynamic> deletePersistentFolder(List<FolderEntity> folders) async {
    return dynamic;
  }
}

class FolderDatasourceExceptionMock extends Mock implements IFolderDatasource {
  @override
  Future deleteFolder(List<FolderEntity> entities) {
    throw DeleteFolderSqliteErrorMock();
  }

  @override
  Future restoreFolder(List<FolderEntity> entities) {
    throw RestoreFolderSqliteErrorMock();
  }

  @override
  Future deletePersistentFolder(List<FolderEntity> entities) {
    throw DeleteFolderPersistentSqliteErrorMock();
  }
}

class FolderDatasourceOutherExceptionMock extends Mock
    implements IFolderDatasource {
  @override
  Future<dynamic> deleteFolder(List<FolderEntity> folders) async {
    throw NoFolderEditedToDeletedSqliteError();
  }

  @override
  Future restoreFolder(List<FolderEntity> entities) {
    throw NoFolderEditedToRestoredSqliteError();
  }
}

class FolderRepositoryMock extends Mock implements IFolderRepository {}

// Failure

class RestoreFolderSqliteErrorMock extends Mock
    implements RestoreFolderSqliteError {}

class DeleteFolderSqliteErrorMock extends Mock
    implements DeleteFolderSqliteError {}

class DeleteFolderPersistentSqliteErrorMock extends Mock
    implements DeleteFolderPersistentSqliteError {}

class AddFolderSqliteErrorMock extends Mock implements AddFolderSqliteError {}

class NotReturnFolderIdSqliteErrorMock extends Mock
    implements NotReturnFolderIdSqliteError {}

class EditFolderSqliteErrorMock extends Mock implements EditFolderSqliteError {}

class NoFolderRecordsChangedSqliteErrorMock extends Mock
    implements NoFolderRecordsChangedSqliteError {}

//* Delete Folder
class DeleteFolderDatasourceMock extends Mock
    implements IDeleteFolderDatasource {}

class DeleteFolderRepositoryMock extends Mock
    implements IDeleteFolderRepository {}

// Failure
class DeleteAllFolderExceptSqliteErrorMock extends Mock
    implements DeleteAllFolderExceptSqliteError {}

//* Dashboard
class GetListDatasourceMock extends Mock implements IGetListDatasource {}

class GetListRepositoryMock extends Mock implements IGetListRepository {}

class FolderEntityMock extends Mock implements FolderEntity {}

// Failure
class GetListFoldersSqliteErrorMock extends Mock
    implements GetListFoldersSqliteError {}

class GetListNotesSqliteErrorMock extends Mock
    implements GetListNotesSqliteError {}

//?-----------------------------------------------------------------------------
//?-----------------------------------------------------------------------------

//* NoteDAO
class NoteDAOMock extends Mock implements NoteDAO {}

class NoteDAONoUpdateFolderMock extends Mock implements NoteDAO {
  @override
  Future<int> updateNotes(List<NoteEntity> records) async {
    return 0;
  }
}

class NoteDAOExceptionMock extends Mock implements NoteDAO {
  @override
  Future<int> updateNotes(List<NoteEntity> records) async {
    throw SqliteExceptionMock();
  }

  @override
  Future<void> deleteNote(int noteId) {
    throw SqliteExceptionMock();
  }

  @override
  Future<int> deletePersistentNotes(List<NoteEntity> records) {
    throw SqliteExceptionMock();
  }
}

//* FolderDAO
class FolderDAOMock extends Mock implements FolderDAO {}

class FolderDAONoUpdateFolderMock extends Mock implements FolderDAO {
  @override
  Future<int> updateFolders(List<FolderEntity> records) async {
    return 0;
  }
}

class FolderDAOExceptionMock extends Mock implements FolderDAO {
  @override
  Future<List<FolderEntity>> findAllFolderChildrens(int folderId) async {
    return [];
  }

  @override
  Future<int> updateFolders(List<FolderEntity> records) async {
    throw SqliteExceptionMock();
  }

  @override
  Future deleteChild(FolderEntity folder) {
    throw SqliteExceptionMock();
  }

  @override
  Future restoreChild(FolderEntity folder) {
    throw SqliteExceptionMock();
  }

  @override
  Future deletePersistentChild(FolderEntity folder) {
    throw SqliteExceptionMock();
  }
}

//* Sqlite Exception
class SqliteExceptionMock extends SqliteException with Mock {
  SqliteExceptionMock() : super(0, '');
}
