import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';

abstract class IFolderDatasource {
  Stream<List<FolderQtdChildView>> getFoldersQtdChild();
}
