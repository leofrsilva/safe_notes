import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';
import 'package:safe_notes/app/shared/errors/failure.dart';

abstract class INoteRepository {
  Future<Either<Failure, dynamic>> addNotes(List<NoteModel> notes);
  Future<Either<Failure, dynamic>> editNote(List<NoteModel> notes);
  Future<Either<Failure, dynamic>> deleteNote(List<NoteModel> notes);
  Future<Either<Failure, dynamic>> restoreNote(List<NoteModel> notes);
  Future<Either<Failure, dynamic>> deletePersistentNote(List<NoteModel> notes);
}
