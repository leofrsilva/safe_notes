import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/error/failure.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';

import '../../domain/repositories/i_manager_folders_repository.dart';
import '../datasources/i_manager_folders_datasource.dart';

class ManagerFoldersRepository extends IManagerFoldersRepository {
  final IManagerFoldersDatasource _datasource;
  ManagerFoldersRepository(this._datasource);

  @override
  Future<Either<Failure, dynamic>> addFolder(FolderModel folder) async {
    try {
      final result = await _datasource.addFolder(folder.entity);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (exception, stacktrace) {
      return Left(UnknownError(
        exception: exception,
        stackTrace: stacktrace,
        label: 'ManagerFoldersRepository-addFolder',
      ));
    }
  }

  @override
  Future<Either<Failure, dynamic>> editFolder(FolderModel folder) async {
    try {
      final result = await _datasource.editFolder(folder.entity);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (exception, stacktrace) {
      return Left(UnknownError(
        exception: exception,
        stackTrace: stacktrace,
        label: 'ManagerFoldersRepository-editFolder',
      ));
    }
  }

  @override
  Future<Either<Failure, dynamic>> deleteFolder(int folderId) async {
    try {
      final result = await _datasource.deleteFolder(folderId);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (exception, stacktrace) {
      return Left(UnknownError(
        exception: exception,
        stackTrace: stacktrace,
        label: 'ManagerFoldersRepository-deleteFolder',
      ));
    }
  }
}