import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';
import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

abstract class IGetListRepository {
  Either<Failure, Stream<List<FolderQtdChildView>>> getFoldersQtdChild();
  Either<Failure, Stream<List<NoteModel>>> getNotes();
}
