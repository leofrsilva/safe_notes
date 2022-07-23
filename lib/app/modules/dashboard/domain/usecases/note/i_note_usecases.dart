import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';
import 'package:safe_notes/app/shared/errors/failure.dart';

abstract class IAddNoteUsecase {
  Future<Either<Failure, dynamic>> call(NoteModel note);
}

abstract class IEditNoteUsecase {
  Future<Either<Failure, dynamic>> call(List<NoteModel> notes);
}

abstract class IDeleteNoteUsecase {
  Future<Either<Failure, dynamic>> call(List<NoteModel> notes);
}

abstract class IRestoreNoteUsecase {
  Future<Either<Failure, dynamic>> call(List<NoteModel> notes);
}

abstract class IDeleteNotePersistentUsecase {
  Future<Either<Failure, dynamic>> call(List<NoteModel> notes);
}
