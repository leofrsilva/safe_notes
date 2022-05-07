import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/error/failure.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';

import '../repositories/i_manager_folders_repository.dart';
import 'i_manager_folders_usecase.dart';

class EditFolderUsecase extends IEditFolderUsecase {
  final IManagerFoldersRepository _repository;
  EditFolderUsecase(this._repository);

  @override
  Future<Either<Failure, dynamic>> call(FolderModel folder) {
    return _repository.editFolder(folder);
  }
}
