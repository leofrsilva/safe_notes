import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

import '../repositories/i_manager_folders_repository.dart';
import 'i_manager_folders_usecase.dart';

class DeleteFolderUsecase extends IDeleteFolderUsecase {
  final IManagerFoldersRepository _repository;
  DeleteFolderUsecase(this._repository);

  @override
  Future<Either<Failure, dynamic>> call(List<FolderModel> folders) {
    return _repository.deleteFolder(folders);
  }
}
