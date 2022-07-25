import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/encrypt/encrypt.dart';
import 'package:safe_notes/app/shared/errors/failure.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';

import '../../repositories/i_folder_repository.dart';
import 'i_folder_usecase.dart';

class RestoreFolderUsecase extends IRestoreFolderUsecase {
  final DataEncrypt _dataEncrypt;
  final IFolderRepository _repository;
  RestoreFolderUsecase(this._repository, this._dataEncrypt);

  @override
  Future<Either<Failure, dynamic>> call(List<FolderModel> folders) async {
    if (_dataEncrypt.isCorrectKey) {
      return await _repository.restoreFolder(folders);
    } else {
      return left(IncorrectEncryptionError());
    }
  }
}
