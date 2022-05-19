import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

abstract class IAddNoteUsecase {
  Future<Either<Failure, dynamic>> call(NoteModel note);
}

abstract class IEditNoteUsecase {
  Future<Either<Failure, dynamic>> call(NoteModel note);
}

abstract class IDeleteNoteEmptyUsecase {
  Future<Either<Failure, dynamic>> call(NoteModel note);
}
