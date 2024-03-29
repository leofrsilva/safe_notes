import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/errors/failure.dart';

abstract class IAddFolderUsecase {
  Future<Either<Failure, dynamic>> call(List<FolderModel> folders);
}

abstract class IEditFolderUsecase {
  Future<Either<Failure, dynamic>> call(FolderModel folder);
}

abstract class IDeleteFolderUsecase {
  Future<Either<Failure, dynamic>> call(List<FolderModel> folders);
}

abstract class IRestoreFolderUsecase {
  Future<Either<Failure, dynamic>> call(List<FolderModel> folders);
}

abstract class IDeleteFolderPersistentUsecase {
  Future<Either<Failure, dynamic>> call(List<FolderModel> folders);
}
