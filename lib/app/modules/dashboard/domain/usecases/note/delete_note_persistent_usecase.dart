import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/error/failure.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';

import '../../repositories/i_note_repository.dart';
import 'i_note_usecases.dart';

class DeleteNotePersistentUsecase extends IDeleteNotePersistentUsecase {
  final INoteRepository _repository;
  DeleteNotePersistentUsecase(this._repository);

  @override
  Future<Either<Failure, dynamic>> call(List<NoteModel> notes) {
    return _repository.deletePersistentNote(notes);
  }
}
