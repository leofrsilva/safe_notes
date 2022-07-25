import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/encrypt/encrypt.dart';
import 'package:safe_notes/app/shared/errors/failure.dart';

import '../../repositories/i_folder_repository.dart';
import 'i_folder_usecase.dart';

class DeleteFolderPersistentUsecase extends IDeleteFolderPersistentUsecase {
  final DataEncrypt _dataEncrypt;
  final IFolderRepository _repository;
  DeleteFolderPersistentUsecase(this._repository, this._dataEncrypt);

  @override
  Future<Either<Failure, dynamic>> call(List<FolderModel> folders) async {
    if (_dataEncrypt.isCorrectKey) {
      return await _repository.deletePersistentFolder(folders);
    } else {
      return left(IncorrectEncryptionError());
    }
  }
}
