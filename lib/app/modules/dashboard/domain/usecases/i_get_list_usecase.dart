import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/errors/failure.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';

abstract class IGetListFoldersUsecase {
  Either<Failure, Stream<List<FolderModel>>> call();
}

abstract class IGetListNotesUsecase {
  Either<Failure, Stream<List<NoteModel>>> call();
}
