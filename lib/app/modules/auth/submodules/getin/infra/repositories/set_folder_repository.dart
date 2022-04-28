import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/database/default.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

import '../../domain/repositories/i_set_folder_repository.dart';
import '../datasources/i_set_folder_datasource.dart';

class SetFolderRepository extends ISetFolderRepository {
  final ISetFolderDatasource _datasource;
  SetFolderRepository(this._datasource);

  @override
  Future<Either<Failure, dynamic>> setDefaultFolder(String uid) async {
    try {
      final defaultFolder = FolderModel(
        folderParent: null,
        level: 0,
        folderId: 0,
        userId: uid,
        name: 'Pastas',
        isDeleted: false,
        dateCreate: DateTime.now(),
        dateModification: DateTime.now(),
        color: DefaultDatabase.colorFolderDefault,
      );
      final result = await _datasource.setDefaultFolder(defaultFolder.entity);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (exception, stacktrace) {
      return Left(UnknownError(
        exception: exception,
        stackTrace: stacktrace,
        label: 'SetFolderRepository-setDefaultFolder',
      ));
    }
  }
}
