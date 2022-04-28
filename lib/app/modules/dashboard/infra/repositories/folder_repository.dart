import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/error/failure.dart';
import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';

import '../../domain/repositories/i_folder_repository.dart';
import '../datasources/i_folder_datasource.dart';

class FolderRepository extends IFolderRepository {
  final IFolderDatasource _datasource;
  FolderRepository(this._datasource);

  @override
  Either<Failure, Stream<List<FolderQtdChildView>>> getFoldersQtdChild() {
    try {
      final strem = _datasource.getFoldersQtdChild();
      return Right(strem);
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (exception, stacktrace) {
      return Left(UnknownError(
        exception: exception,
        stackTrace: stacktrace,
        label: 'FolderRepository-getFoldersQtdChild',
      ));
    }
  }
}
