import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/encrypt/encrypt.dart';
import 'package:safe_notes/app/shared/errors/failure.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';

import '../../repositories/i_note_repository.dart';
import 'i_note_usecases.dart';

class EditNoteUsecase extends IEditNoteUsecase {
  final DataEncrypt _dataEncrypt;
  final INoteRepository _repository;
  EditNoteUsecase(this._repository, this._dataEncrypt);

  @override
  Future<Either<Failure, dynamic>> call(List<NoteModel> notes) async {
    if (_dataEncrypt.isCorrectKey) {
      return await _repository.editNote(notes);
    } else {
      return left(IncorrectEncryptionError());
    }
  }
}
