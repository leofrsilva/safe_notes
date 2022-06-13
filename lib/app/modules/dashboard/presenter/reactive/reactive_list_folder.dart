import 'package:flutter/foundation.dart';
import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';

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
      Map<FolderQtdChildView, bool> mapFoldersIsExpanded) {
    return mapFoldersIsExpanded.map<int, bool>((folder, isExpanded) {
      return MapEntry(folder.id, isExpanded);
    });
  }
}

class ReactiveListFolder extends ChangeNotifier implements IReactiveListFolder {
  final _listFoldersIsExpanded = <FolderQtdChildView, bool>{};
  final _deleted = _ReactiveDeletedFolder();
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
  ValueNotifier<int> get deleted => _deleted;

  @override
  List<FolderQtdChildView> get listFolderDeleted {
    return _deleted.listFolderDeleted;
  }

  //* -- EXPANDED
  @override
  addAllFolder(List<FolderQtdChildView> folders) {
    final listFoldersAux =
        Map<FolderQtdChildView, bool>.from(_listFoldersIsExpanded);
    removeAllFolder();
    _loadListFolder(folders);

    if (_buffer.isEmpty) {
      _listFoldersIsExpanded.updateAll((folder, isExpanded) {
        bool? expanded;
        listFoldersAux.forEach((folderAux, isExpandedAux) {
          if (folderAux.id == folder.id) expanded = isExpandedAux;
        });
        if (expanded != null) return expanded!;
        return isExpanded;
      });
    } else {
      _buffer.clearBufferExpanded();
    }

    _deleted.countDeleted = folders;
    notifyListeners();
  }

  _loadListFolder(List<FolderQtdChildView> listFolderQtdChildView) {
    bool isExpanded;
    for (var folderQtdChildView in listFolderQtdChildView) {
      if (_buffer.isEmpty) {
        if (folderQtdChildView.level > 0) {
          isExpanded = false;
        } else {
          isExpanded = true;
        }
      } else {
        isExpanded = _buffer.getIsExpanded(folderQtdChildView.id);
      }
      add(folderQtdChildView, isExpanded);
    }
  }

  _notExpandedChildrens(int id) {
    _listFoldersIsExpanded.updateAll((folder, isExpanded) {
      if (folder.id == id) return false;
      if (folder.parentId == id) {
        _notExpandedChildrens(folder.id);
      }
      return isExpanded;
    });
  }

  @override
  notExpanded({required int folderId}) {
    _notExpandedChildrens(folderId);
    notifyListeners();
  }

  @override
  expanded({required int folderId}) {
    _listFoldersIsExpanded.updateAll((key, value) {
      if (key.id == folderId) return true;
      return value;
    });
    notifyListeners();
  }

  @override
  bool checkFolderIsExpanded(int id) {
    var result = false;
    _listFoldersIsExpanded.forEach((folder, isExpanded) {
      if (folder.id == id) {
        result = isExpanded;
      }
    });
    return result;
  }

  //* -- LIST FOLDER
  @override
  FolderQtdChildView getFolder(int id) {
    return _listFoldersIsExpanded.keys.firstWhere((folder) {
      return folder.id == id;
    });
  }

  @override
  List<FolderQtdChildView> get listFolder {
    _listFoldersIsExpanded.keys.toList().sort((previous, posterior) {
      return previous.id.compareTo(posterior.id);
    });
    return _listFoldersIsExpanded.keys
        .where((folder) => folder.isDeleted == 0)
        .toList();
  }

  @override
  int qtdChildrenFolder(int folderId) {
    return _listFoldersIsExpanded.keys.where((folder) {
      return folder.parentId == folderId && folder.isDeleted == 0;
    }).length;
  }

  @override
  List<FolderQtdChildView> childrensFolder(int folderId) {
    return _listFoldersIsExpanded.keys
        .where((folder) => folder.parentId == folderId && folder.isDeleted == 0)
        .toList();
  }

  List<FolderQtdChildView> _getParent(FolderQtdChildView folder) {
    var folders = <FolderQtdChildView>[folder];
    int parentId = folder.parentId ?? 0;

    for (var folderChild in _listFoldersIsExpanded.keys) {
      if (folderChild.id == parentId) {
        folders.addAll(_getParent(folderChild));
      }
    }
    return folders;
  }

  @override
  List<FolderQtdChildView> listDescendants(FolderQtdChildView folder) {
    var descendants = <FolderQtdChildView>[];

    descendants.addAll(_getParent(folder));
    return descendants;
  }

  //* -- FUNCTION FOR NAME FOLDER
  @override
  int qtdNameFolder(int parentId, int level) {
    var count = 0;
    for (var folder in listFolder) {
      if (folder.name.trim().contains('Pasta ') &&
          folder.parentId == parentId &&
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
  bool checkNameAlreadyExists(FolderQtdChildView folderer) {
    bool exists = false;
    for (var folder in listFolder) {
      if (folder.level == folderer.level &&
          folder.parentId == folderer.parentId) {
        if (folder.name == folderer.name) {
          exists = true;
        }
      }
    }
    return exists;
  }

  void add(FolderQtdChildView folder, bool isExpanded) {
    _listFoldersIsExpanded.addAll({folder: isExpanded});
  }

  void removeAllFolder() {
    _listFoldersIsExpanded.clear();
  }
}

class _ReactiveDeletedFolder extends ValueNotifier<int> {
  final _listFolders = <FolderQtdChildView>[];
  _ReactiveDeletedFolder({int value = 0}) : super(value);

  set countDeleted(List<FolderQtdChildView> folders) {
    _listFolders.clear();
    _listFolders.addAll(folders);
    value = listFolderDeleted.length;
    notifyListeners();
  }

  FolderQtdChildView _findSuperParent(FolderQtdChildView currentFolder) {
    var parentFolder = currentFolder;
    _listFolders
      ..sort((previous, posterior) {
        return previous.id.compareTo(posterior.id);
      })
      ..sort((previous, posterior) {
        return posterior.level.compareTo(previous.level);
      });

    int superParentId = parentFolder.parentId ?? 0;
    for (var folder in _listFolders) {
      if (folder.id == superParentId && folder.isDeleted == 1) {
        superParentId = folder.parentId ?? 0;
        parentFolder = folder;
      }
    }
    return parentFolder;
  }

  List<FolderQtdChildView> get listFolderDeleted {
    List<FolderQtdChildView> list = [];
    for (var folder in _listFolders) {
      if (folder.level > 0 && folder.isDeleted == 1) {
        var superParent = _findSuperParent(folder);
        if (!list.contains(superParent)) {
          list.add(_findSuperParent(folder));
        }
      }
    }
    // return list..sort((previous, posterior) {
    //     return previous.dateModification.compareTo(posterior.dateModification);
    //   });
    return list;
  }
}
