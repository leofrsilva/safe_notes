import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

import '../../repositories/i_set_folder_repository.dart';
import 'i_set_folder_usecase.dart';

class SetFolderUsecase extends ISetFolderUsecase {
  ISetFolderRepository _repository;
  SetFolderUsecase(this._repository);

  @override
  Future<Either<Failure, dynamic>> call(String uid) {
    return _repository.setDefaultFolder(uid);
  }
}
