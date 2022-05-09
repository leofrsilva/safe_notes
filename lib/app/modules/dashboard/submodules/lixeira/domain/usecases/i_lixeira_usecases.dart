import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

abstract class IGetNotesDeletedUsecase {
  Future<Either<Failure, List<NoteModel>>> call();
}
