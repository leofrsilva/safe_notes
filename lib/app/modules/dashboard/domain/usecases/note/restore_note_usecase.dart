import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/errors/failure.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';

import '../../repositories/i_note_repository.dart';
import 'i_note_usecases.dart';

class RestoreNoteUsecase extends IRestoreNoteUsecase {
  final INoteRepository _repository;
  RestoreNoteUsecase(this._repository);

  @override
  Future<Either<Failure, dynamic>> call(List<NoteModel> notes) async {
    return await _repository.restoreNote(notes);
  }
}
