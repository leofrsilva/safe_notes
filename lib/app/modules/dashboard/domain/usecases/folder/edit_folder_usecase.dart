import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/errors/failure.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';

import '../../repositories/i_folder_repository.dart';
import 'i_folder_usecase.dart';

class EditFolderUsecase extends IEditFolderUsecase {
  final IFolderRepository _repository;
  EditFolderUsecase(this._repository);

  @override
  Future<Either<Failure, dynamic>> call(FolderModel folder) async {
    return await _repository.editFolder(folder);
  }
}
