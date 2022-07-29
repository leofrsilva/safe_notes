import 'package:safe_notes/app/shared/database/default.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';

import 'i_reactive_list_folder.dart';

class _BufferExpanded {
  final _bufferExpanded = <int, bool>{};

  set bufferExpanded(Map<int, bool> map) {
    _bufferExpanded.addAll(map);
  }

  void clearBufferExpanded() {
    _bufferExpanded.clear();
  }

  bool get isEmpty => _bufferExpanded.isEmpty;

  bool getIsExpanded(int folderId) {
    return _bufferExpanded[folderId] ?? false;
  }

  Map<int, bool> getBufferExpanded(
      Map<FolderModel, bool> mapFoldersIsExpanded) {
    return mapFoldersIsExpanded.map<int, bool>((folder, isExpanded) {
      return MapEntry(folder.folderId, isExpanded);
    });
  }
}

class ReactiveListFolder implements IReactiveListFolder {
  final _listFoldersIsExpanded = <FolderModel, bool>{};
  final _deleted = _DeletedFolders();
  final _buffer = _BufferExpanded();

  //* -- BUFFER
  @override
  setBufferExpanded(Map<int, bool> map) {
    _buffer.bufferExpanded = map;
  }

  @override
  Map<int, bool> get getBufferExpanded {
    return _buffer.getBufferExpanded(_listFoldersIsExpanded);
  }

  //* -- LIST DELETED
  @override
  int get qtdFolderdeleted => _deleted.qtd;

  @override
  List<FolderModel> get listFolderDeleted {
    return _deleted.listFolderDeleted;
  }

  @override
  List<FolderModel> listFolderDeletedById(int folderId) {
    return _deleted.listFolderDeletedById(folderId);
  }

  //* -- EXPANDED
  @override
  addAllFolder(List<FolderModel> folders) {
    final listFoldersAux = Map<FolderModel, bool>.from(_listFoldersIsExpanded);
    removeAllFolder();
    _loadListFolder(folders);

    if (_buffer.isEmpty) {
      _listFoldersIsExpanded.updateAll((folder, isExpanded) {
        bool? expanded;
        listFoldersAux.forEach((folderAux, isExpandedAux) {
          if (folderAux.folderId == folder.folderId) expanded = isExpandedAux;
        });
        if (expanded != null) return expanded!;
        return isExpanded;
      });
    } else {
      _buffer.clearBufferExpanded();
    }

    _deleted.countDeleted = folders;
  }

  _loadListFolder(List<FolderModel> listFolderModel) {
    bool isExpanded;
    for (var folderModel in listFolderModel) {
      if (_buffer.isEmpty) {
        if (folderModel.level > 0) {
          isExpanded = false;
        } else {
          isExpanded = true;
        }
      } else {
        isExpanded = _buffer.getIsExpanded(folderModel.folderId);
      }
      add(folderModel, isExpanded);
    }
  }

  _notExpandedChildrens(int id) {
    _listFoldersIsExpanded.updateAll((folder, isExpanded) {
      if (folder.folderId == id) return false;
      if (folder.folderParent == id) {
        _notExpandedChildrens(folder.folderId);
      }
      return isExpanded;
    });
  }

  @override
  notExpanded({required int folderId}) {
    _notExpandedChildrens(folderId);
  }

  @override
  expanded({required int folderId}) {
    _listFoldersIsExpanded.updateAll((key, value) {
      if (key.folderId == folderId) return true;
      return value;
    });
  }

  @override
  bool checkFolderIsExpanded(int id) {
    var result = false;
    _listFoldersIsExpanded.forEach((folder, isExpanded) {
      if (folder.folderId == id) {
        result = isExpanded;
      }
    });
    return result;
  }

  //* -- LIST FOLDER
  @override
  List<FolderModel> get allFolders {
    return _listFoldersIsExpanded.keys.toList();
  }

  @override
  FolderModel getFolder(int id) {
    return _listFoldersIsExpanded.keys.firstWhere((folder) {
      return folder.folderId == id;
    });
  }

  @override
  List<FolderModel> get listFolder {
    _listFoldersIsExpanded.keys.toList().sort((previous, posterior) {
      return previous.folderId.compareTo(posterior.folderId);
    });
    return _listFoldersIsExpanded.keys
        .where((folder) => folder.isDeleted == false)
        .toList();
  }

  @override
  int qtdChildrenFolder(int folderId) {
    return _listFoldersIsExpanded.keys.where((folder) {
      return folder.folderParent == folderId && folder.isDeleted == false;
    }).length;
  }

  @override
  List<FolderModel> childrensFolder(int folderId) {
    return _listFoldersIsExpanded.keys
        .where((folder) =>
            folder.folderParent == folderId && folder.isDeleted == false)
        .toList();
  }

  List<FolderModel> _getParent(FolderModel folder) {
    var folders = <FolderModel>[folder];
    int parentId = folder.folderParent ?? 0;

    for (var folderChild in _listFoldersIsExpanded.keys) {
      if (folderChild.folderId == parentId) {
        folders.addAll(_getParent(folderChild));
      }
    }
    return folders;
  }

  @override
  List<FolderModel> listDescendants(FolderModel folder) {
    var descendants = <FolderModel>[];

    descendants.addAll(_getParent(folder));
    return descendants.reversed.toList();
  }

  List<FolderModel> _getParentFolder(FolderModel folder) {
    var folders = <FolderModel>[folder];
    int parentId = folder.folderId;

    var listFolder = _listFoldersIsExpanded.keys
        .where((folderChild) =>
            folderChild.folderId != parentId &&
            folderChild.folderId != DefaultDatabase.folderDefault.folderId)
        .toList();

    for (var folderChild in listFolder) {
      if (folderChild.folderParent == parentId) {
        folders.addAll(_getParentFolder(folderChild));
      }
    }
    return folders;
  }

  @override
  List<FolderModel> listDescendantsFolder(FolderModel folder) {
    var descendants = <FolderModel>[];

    descendants.addAll(_getParentFolder(folder));
    return descendants.toList();
  }

  //* -- FUNCTION FOR NAME FOLDER
  @override
  int qtdNameFolder(int parentId, int level) {
    var count = 0;
    for (var folder in listFolder) {
      if (folder.name.trim().contains('Pasta ') &&
          folder.folderParent == parentId &&
          folder.level == level) {
        final itens = folder.name.split(' ');
        if (itens.length == 2) {
          int? number = int.tryParse(itens[1]);
          if (number != null) {
            if (number == count + 1) {
              count = count + 1;
            }
          }
        }
      }
    }
    return ++count;
  }

  @override
  bool checkNameAlreadyExists(FolderModel folderer, String nameFolder) {
    bool exists = false;
    for (var folder in listFolder) {
      if (folder.level == folderer.level &&
          folder.folderParent == folderer.folderParent) {
        if (folder.name != folderer.name && folder.name == nameFolder) {
          exists = true;
        }
      }
    }
    return exists;
  }

  void add(FolderModel folder, bool isExpanded) {
    _listFoldersIsExpanded.addAll({folder: isExpanded});
  }

  void removeAllFolder() {
    _listFoldersIsExpanded.clear();
  }
}

class _DeletedFolders {
  final _listFolders = <FolderModel>[];

  int _qtd = 0;
  int get qtd => _qtd;

  set countDeleted(List<FolderModel> folders) {
    _listFolders.clear();
    _listFolders.addAll(folders);
    _qtd = listFolderDeleted.length;
  }

  FolderModel _findSuperParent(FolderModel currentFolder) {
    var parentFolder = currentFolder;
    _listFolders
      ..sort((previous, posterior) {
        return previous.folderId.compareTo(posterior.folderId);
      })
      ..sort((previous, posterior) {
        return posterior.level.compareTo(previous.level);
      });

    int superParentId = parentFolder.folderParent ?? 0;
    for (var folder in _listFolders) {
      if (folder.folderId == superParentId && folder.isDeleted == true) {
        superParentId = folder.folderParent ?? 0;
        parentFolder = folder;
      }
    }
    return parentFolder;
  }

  List<FolderModel> get listFolderDeleted {
    List<FolderModel> list = [];
    for (var folder in _listFolders) {
      if (folder.level > 0 && folder.isDeleted == true) {
        // print(folder.name);
        var superParent = _findSuperParent(folder);
        if (!list.contains(superParent)) {
          list.add(_findSuperParent(folder));
        }
      }
    }
    return list;
  }

  List<FolderModel> listFolderDeletedById(int folderId) {
    return _listFolders
        .where((folder) =>
            folder.isDeleted == true && folder.folderParent == folderId)
        .toList();
  }
}
