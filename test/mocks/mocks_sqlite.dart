import 'package:safe_notes/app/modules/auth/submodules/getin/domain/errors/getin_failures.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/domain/repositories/i_delete_folder_repository.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/infra/datasources/i_delete_folder_datasource.dart';
import 'package:safe_notes/app/modules/dashboard/domain/errors/folder_failures.dart';
import 'package:safe_notes/app/modules/dashboard/domain/repositories/i_folder_repository.dart';
import 'package:safe_notes/app/modules/dashboard/infra/datasources/i_folder_datasource.dart';
import 'package:safe_notes/app/shared/database/daos/folder_dao.dart';
import 'package:safe_notes/app/shared/database/entities/folder_entity.dart';

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

//* Sqlite Exception
class SqliteExceptionMock extends SqliteException with Mock {
  SqliteExceptionMock() : super(0, '');
}
