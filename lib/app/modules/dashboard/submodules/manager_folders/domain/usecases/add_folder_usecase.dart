import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

import '../repositories/i_manager_folders_repository.dart';
import 'i_manager_folders_usecase.dart';

class AddFolderUsecase extends IAddFolderUsecase {
  final IManagerFoldersRepository _repository;
  AddFolderUsecase(this._repository);

  @override
  Future<Either<Failure, dynamic>> call(FolderModel folder) {
    return _repository.addFolder(folder);
  }
}
