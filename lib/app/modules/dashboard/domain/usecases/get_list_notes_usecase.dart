import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';
import 'package:safe_notes/app/shared/errors/failure.dart';

import '../repositories/i_get_list_repository.dart';
import 'i_get_list_usecase.dart';

class GetListNotesUsecase extends IGetListNotesUsecase {
  final IGetListRepository _repository;
  GetListNotesUsecase(this._repository);

  @override
  Either<Failure, Stream<List<NoteModel>>> call() {
    return _repository.getNotes();
  }
}
