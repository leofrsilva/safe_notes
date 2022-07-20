import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

import '../../repositories/i_folder_repository.dart';
import 'i_folder_usecase.dart';

class DeleteFolderUsecase extends IDeleteFolderUsecase {
  final IFolderRepository _repository;
  DeleteFolderUsecase(this._repository);

  @override
  Future<Either<Failure, dynamic>> call(List<FolderModel> folders) async {
    return await _repository.deleteFolder(folders);
  }
}
