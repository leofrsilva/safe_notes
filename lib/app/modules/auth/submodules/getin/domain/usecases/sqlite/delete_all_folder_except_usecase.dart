import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

import '../../repositories/i_delete_folder_repository.dart';
import 'i_delete_all_folder_except_usecase.dart';

class DeleteAllFolderExceptUsecase extends IDeleteAllFolderExceptUsecase {
  final IDeleteFolderRepository _repository;
  DeleteAllFolderExceptUsecase(this._repository);

  @override
  Future<Either<Failure, dynamic>> call(int folderId) async {
    return await _repository.deleteAllFolderExcept(folderId);
  }
}
