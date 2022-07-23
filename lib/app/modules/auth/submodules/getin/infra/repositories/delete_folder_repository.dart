import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/errors/failure.dart';

import '../../domain/repositories/i_delete_folder_repository.dart';
import '../datasources/i_delete_folder_datasource.dart';

class DeleteFolderRepository extends IDeleteFolderRepository {
  final IDeleteFolderDatasource _datasource;
  DeleteFolderRepository(this._datasource);

  @override
  Future<Either<Failure, dynamic>> deleteAllFolderExcept(int folderId) async {
    try {
      final result = await _datasource.deleteAllFolderExcept(folderId);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (exception, stacktrace) {
      return Left(UnknownError(
        exception: exception,
        stackTrace: stacktrace,
        label: 'DeleteFolderRepository-deleteAllFolderExcept',
      ));
    }
  }
}
