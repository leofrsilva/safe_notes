import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/error/failure.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';
import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';

abstract class IGetListFoldersUsecase {
  Either<Failure, Stream<List<FolderQtdChildView>>> call();
}

abstract class IGetListNotesUsecase {
  Either<Failure, Stream<List<NoteModel>>> call();
}
