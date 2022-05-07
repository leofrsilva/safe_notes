import 'package:safe_notes/app/modules/auth/submodules/getin/domain/errors/getin_failures.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/manager_folders/domain/errors/manager_folders_failures.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/manager_folders/domain/repositories/i_manager_folders_repository.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/manager_folders/infra/datasources/i_manager_folders_datasource.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/domain/repositories/i_delete_folder_repository.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/infra/datasources/i_delete_folder_datasource.dart';
import 'package:safe_notes/app/modules/dashboard/domain/errors/folder_failures.dart';
import 'package:safe_notes/app/modules/dashboard/domain/repositories/i_folder_repository.dart';
import 'package:safe_notes/app/modules/dashboard/infra/datasources/i_folder_datasource.dart';
import 'package:safe_notes/app/shared/database/daos/folder_dao.dart';
import 'package:safe_notes/app/shared/database/entities/folder_entity.dart';

//* Manager Folder
class ManagerFoldersDatasourceMock extends Mock
    implements IManagerFoldersDatasource {}

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

//* Folder
class FolderDatasourceMock extends Mock implements IFolderDatasource {}

class FolderRepositoryMock extends Mock implements IFolderRepository {}

class FolderEntityMock extends Mock implements FolderEntity {}

// Failure
class GetListFoldersSqliteErrorMock extends Mock
    implements GetListFoldersSqliteError {}

//* FolderDAO
class FolderDAOMock extends Mock implements FolderDAO {}

class FolderDAONoUpdateFolderMock extends Mock implements FolderDAO {
  @override
  Future<int> updateFolders(List<FolderEntity> records) async {
    return 0; //100;
  }
}

class FolderDAOExceptionMock extends Mock implements FolderDAO {
  @override
  Future<int> updateFolders(List<FolderEntity> records) async {
    throw SqliteExceptionMock();
  }

  @override
  Future<void> deleteFolder(int folderId) {
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
