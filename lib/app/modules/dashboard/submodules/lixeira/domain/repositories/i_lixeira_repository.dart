import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

abstract class ILixeiraRepository {
  Future<Either<Failure, List<NoteModel>>> getNotesDeleted();
}
