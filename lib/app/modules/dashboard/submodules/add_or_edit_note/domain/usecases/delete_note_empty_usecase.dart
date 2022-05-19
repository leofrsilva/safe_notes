import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/error/failure.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';

import '../repositories/i_note_repository.dart';
import 'i_note_usecases.dart';

class DeleteNoteEmptyUsecase extends IDeleteNoteEmptyUsecase {
  final INoteRepository _repository;
  DeleteNoteEmptyUsecase(this._repository);

  @override
  Future<Either<Failure, dynamic>> call(NoteModel note) {
    return _repository.deletePersistentNote(note);
  }
}
