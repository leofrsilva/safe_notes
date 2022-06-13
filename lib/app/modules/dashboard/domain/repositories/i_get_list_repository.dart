import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

abstract class IGetListRepository {
  Either<Failure, Stream<List<FolderModel>>> getFolders();
  Either<Failure, Stream<List<NoteModel>>> getNotes();
}
