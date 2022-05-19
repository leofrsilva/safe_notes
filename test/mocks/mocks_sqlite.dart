import 'package:sqlite3/sqlite3.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/add_or_edit_note/domain/errors/add_or_edit_failures.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/add_or_edit_note/domain/repositories/i_note_repository.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/add_or_edit_note/infra/datasources/i_note_datasource.dart';
import 'package:safe_notes/app/shared/database/entities/note_entity.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/domain/errors/getin_failures.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/lixeira/domain/errors/lixeira_failures.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/lixeira/domain/repositories/i_lixeira_repository.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/lixeira/infra/datasources/i_lixeira_datasource.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/manager_folders/domain/errors/manager_folders_failures.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/manager_folders/domain/repositories/i_manager_folders_repository.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/manager_folders/infra/datasources/i_manager_folders_datasource.dart';
import 'package:safe_notes/app/shared/database/daos/note_dao.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/domain/repositories/i_delete_folder_repository.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/infra/datasources/i_delete_folder_datasource.dart';
import 'package:safe_notes/app/modules/dashboard/domain/errors/folder_failures.dart';
import 'package:safe_notes/app/modules/dashboard/domain/repositories/i_get_list_repository.dart';
import 'package:safe_notes/app/modules/dashboard/infra/datasources/i_get_list_datasource.dart';
import 'package:safe_notes/app/shared/database/daos/folder_dao.dart';
import 'package:safe_notes/app/shared/database/entities/folder_entity.dart';

//* Lixeira
class LixeiraDatasourceMock extends Mock implements ILixeiraDatasource {}

class LixeiraRepositoryMock extends Mock implements ILixeiraRepository {}

// Failure
class GetNotesDeletedSqliteErrorMock extends Mock
    implements GetNotesDeletedSqliteError {}

//* Note
class NoteRepositoryMock extends Mock implements INoteRepository {}

class NoteDatasourceMock extends Mock implements INoteDatasource {}

// Failure
class AddNoteSqliteErrorMock extends Mock implements AddNoteSqliteError {}

class EditNoteSqliteErrorMock extends Mock implements EditNoteSqliteError {}

class DeleteNoteEmptySqliteErrorMock extends Mock
    implements DeleteNoteEmptySqliteError {}

//* Manager Folder
class ManagerFoldersDatasourceMock extends Mock
    implements IManagerFoldersDatasource {
  @override
  Future<dynamic> deleteFolder(List<FolderEntity> folders) async {
    return dynamic;
  }
}

class ManagerFoldersDatasourceExceptionMock extends Mock
    implements IManagerFoldersDatasource {
  @override
  Future<dynamic> deleteFolder(List<FolderEntity> folders) async {
    throw DeleteFolderSqliteErrorMock();
  }
}

class ManagerFoldersRepositoryMock extends Mock
    implements IManagerFoldersRepository {}

// Failure
class DeleteFolderSqliteErrorMock extends Mock
    implements DeleteFolderSqliteError {}

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
  Future<void> deletePersistentNote(NoteEntity person) async {
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
  Future<int> updateFolders(List<FolderEntity> records) async {
    throw SqliteExceptionMock();
  }

  @override
  Future delete(int folderId) {
    throw SqliteExceptionMock();
  }
}

//* Sqlite Exception
class SqliteExceptionMock extends SqliteException with Mock {
  SqliteExceptionMock() : super(0, '');
}
