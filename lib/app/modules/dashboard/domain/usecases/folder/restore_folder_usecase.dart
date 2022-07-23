import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/errors/failure.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';

import '../../repositories/i_folder_repository.dart';
import 'i_folder_usecase.dart';

class RestoreFolderUsecase extends IRestoreFolderUsecase {
  final IFolderRepository _repository;
  RestoreFolderUsecase(this._repository);

  @override
  Future<Either<Failure, dynamic>> call(List<FolderModel> folders) async {
    return await _repository.restoreFolder(folders);
  }
}
