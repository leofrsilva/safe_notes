import 'package:safe_notes/app/shared/database/models/folder_model.dart';

abstract class IReactiveListFolder {
  // Buffer
  setBufferExpanded(Map<int, bool> map);

  Map<int, bool> get getBufferExpanded;

  // Deleted
  int get qtdFolderdeleted;

  List<FolderModel> get listFolderDeleted;

  // Expanded
  addAllFolder(List<FolderModel> folders);

  expanded({required int folderId});

  notExpanded({required int folderId});

  bool checkFolderIsExpanded(int id);

  // List Folder
  FolderModel getFolder(int id);

  int qtdChildrenFolder(int folderId);

  List<FolderModel> get listFolder;

  List<FolderModel> childrensFolder(int folderId);

  List<FolderModel> listDescendants(FolderModel folder);

  // Function for Name Folder
  int qtdNameFolder(int parentId, int level);

  bool checkNameAlreadyExists(FolderModel folderer);
}
