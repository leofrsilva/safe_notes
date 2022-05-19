import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/error/failure.dart';
import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';

import '../repositories/i_get_list_repository.dart';
import 'i_folder_usecase.dart';

class GetListFoldersUsecase extends IGetListFoldersUsecase {
  final IGetListRepository _repository;
  GetListFoldersUsecase(this._repository);

  @override
  Either<Failure, Stream<List<FolderQtdChildView>>> call() {
    return _repository.getFoldersQtdChild();
  }
}
