import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/error/failure.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';

import '../../domain/repositories/i_folder_repository.dart';
import '../datasources/i_folder_datasource.dart';

class FolderRepository extends IFolderRepository {
  final IFolderDatasource _datasource;
  FolderRepository(this._datasource);

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
        label: 'FolderRepository-addFolder',
      ));
    }
  }

  @override
  Future<Either<Failure, dynamic>> editFolder(FolderModel folder) async {
    try {
      final result = await _datasource.editFolder(folder);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (exception, stacktrace) {
      return Left(UnknownError(
        exception: exception,
        stackTrace: stacktrace,
        label: 'FolderRepository-editFolder',
      ));
    }
  }

  @override
  Future<Either<Failure, dynamic>> deleteFolder(
      List<FolderModel> folders) async {
    try {
      final entities = folders
          .map((folder) => folder
              .copyWith(
                isDeleted: true,
                dateDeletion: DateTime.now(),
              )
              .entity)
          .toList();
      final result = await _datasource.deleteFolder(entities);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (exception, stacktrace) {
      return Left(UnknownError(
        exception: exception,
        stackTrace: stacktrace,
        label: 'FolderRepository-deleteFolder',
      ));
    }
  }

  @override
  Future<Either<Failure, dynamic>> restoreFolder(
      List<FolderModel> folders) async {
    try {
      final entities = folders
          .map((folder) => folder
              .copyWith(
                isDeleted: false,
                dateDeletion: null,
              )
              .entity)
          .toList();
      final result = await _datasource.restoreFolder(entities);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (exception, stacktrace) {
      return Left(UnknownError(
        exception: exception,
        stackTrace: stacktrace,
        label: 'FolderRepository-restoreFolder',
      ));
    }
  }

  @override
  Future<Either<Failure, dynamic>> deletePersistentFolder(
      List<FolderModel> folders) async {
    try {
      final result = await _datasource.deletePersistentFolder(
        folders.map((folder) => folder.entity).toList(),
      );
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (exception, stacktrace) {
      return Left(UnknownError(
        exception: exception,
        stackTrace: stacktrace,
        label: 'FolderRepository-deletePersistentFolder',
      ));
    }
  }
}
