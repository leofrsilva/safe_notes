import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

import '../../repositories/i_folder_repository.dart';
import 'i_folder_usecase.dart';

class AddFolderUsecase extends IAddFolderUsecase {
  final IFolderRepository _repository;
  AddFolderUsecase(this._repository);

  @override
  Future<Either<Failure, dynamic>> call(FolderModel folder) {
    return _repository.addFolder(folder);
  }
}
