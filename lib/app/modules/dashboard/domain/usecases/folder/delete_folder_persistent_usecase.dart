import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/errors/failure.dart';

import '../../repositories/i_folder_repository.dart';
import 'i_folder_usecase.dart';

class DeleteFolderPersistentUsecase extends IDeleteFolderPersistentUsecase {
  final IFolderRepository _repository;
  DeleteFolderPersistentUsecase(this._repository);

  @override
  Future<Either<Failure, dynamic>> call(List<FolderModel> folders) async {
    return await _repository.deletePersistentFolder(folders);
  }
}
