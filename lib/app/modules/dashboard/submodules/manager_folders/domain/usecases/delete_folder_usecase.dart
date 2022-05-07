import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

import '../repositories/i_manager_folders_repository.dart';
import 'i_manager_folders_usecase.dart';

class DeleteFolderUsecase extends IDeleteFolderUsecase {
  final IManagerFoldersRepository _repository;
  DeleteFolderUsecase(this._repository);

  @override
  Future<Either<Failure, dynamic>> call(int folderId) {
    return _repository.deleteFolder(folderId);
  }
}
