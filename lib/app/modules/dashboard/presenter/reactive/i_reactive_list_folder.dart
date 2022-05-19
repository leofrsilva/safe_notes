import 'package:flutter/foundation.dart';
import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';

abstract class IReactiveListFolder {
  // Buffer
  setBufferExpanded(Map<int, bool> map);

  Map<int, bool> get getBufferExpanded;

  // Deleted
  ValueNotifier<int> get deleted;

  List<FolderQtdChildView> get listFolderDeleted;

  // Expanded
  addAllFolder(List<FolderQtdChildView> folders);

  expanded({required int folderId});

  notExpanded({required int folderId});

  bool checkFolderIsExpanded(int id);

  // List Folder
  FolderQtdChildView getFolder(int id);

  int qtdChildrenFolder(int folderId);

  List<FolderQtdChildView> get listFolder;

  List<FolderQtdChildView> childrensFolder(int folderId);

  // Function for Name Folder
  int qtdNameFolder(int parentId, int level);

  bool checkNameAlreadyExists(FolderQtdChildView folderer);
}
