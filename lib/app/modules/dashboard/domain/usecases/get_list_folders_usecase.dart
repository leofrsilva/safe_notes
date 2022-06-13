import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

import '../repositories/i_get_list_repository.dart';
import 'i_folder_usecase.dart';

class GetListFoldersUsecase extends IGetListFoldersUsecase {
  final IGetListRepository _repository;
  GetListFoldersUsecase(this._repository);

  @override
  Either<Failure, Stream<List<FolderModel>>> call() {
    return _repository.getFolders();
  }
}
