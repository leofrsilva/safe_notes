import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

abstract class IFolderRepository {
  Either<Failure, Stream<List<FolderQtdChildView>>> getFoldersQtdChild();
}
