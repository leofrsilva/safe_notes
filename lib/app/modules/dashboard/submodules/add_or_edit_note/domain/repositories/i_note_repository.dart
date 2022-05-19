import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

abstract class INoteRepository {
  Future<Either<Failure, dynamic>> addNote(NoteModel note);
  Future<Either<Failure, dynamic>> editNote(NoteModel note);
  Future<Either<Failure, dynamic>> deletePersistentNote(NoteModel note);
}
