import 'package:safe_notes/app/shared/database/models/folder_model.dart';

abstract class IReactiveListFolder {
  // Buffer
  setBufferExpanded(Map<int, bool> map);

  Map<int, bool> get getBufferExpanded;

  // Deleted
  int get qtdFolderdeleted;

  List<FolderModel> get listFolderDeleted;

  List<FolderModel> listFolderDeletedById(int folderId);

  // Expanded
  addAllFolder(List<FolderModel> folders);

  expanded({required int folderId});

  notExpanded({required int folderId});

  bool checkFolderIsExpanded(int id);

  // List Folder
  List<FolderModel> get allFolders;

  FolderModel getFolder(int id);

  int qtdChildrenFolder(int folderId);

  List<FolderModel> get listFolder;

  List<FolderModel> childrensFolder(int folderId);

  List<FolderModel> listDescendants(FolderModel folder);

  List<FolderModel> listDescendantsFolder(FolderModel folder);

  // Function for Name Folder
  int qtdNameFolder(int parentId, int level);

  bool checkNameAlreadyExists(FolderModel folderer, String nameFolder);
}
