import 'package:flutter/foundation.dart';
import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';

class ReactiveListFolder extends ChangeNotifier {
  final _listFoldersIsExpanded = <FolderQtdChildView, bool>{};
  final _qtdDeleted = ValueNotifier<int>(0);

  // ValueNotifier<int> qtd
  set _countDeleted(List<FolderQtdChildView> folders) {
    int count = 0;
    for (var folder in folders) {
      if (folder.isDeleted == 1) count++;
    }
    _qtdDeleted.value = count;
  }

  List<FolderQtdChildView> get list {
    _listFoldersIsExpanded.keys.forEach((folder) {
      print('${folder.name}  |  ${folder.isDeleted}');
    });
    _listFoldersIsExpanded.keys.toList().sort((previous, posterior) {
      return previous.id.compareTo(posterior.id);
    });
    return _listFoldersIsExpanded.keys
        .where((folder) => folder.isDeleted == 0)
        .toList();
  }

  int qtdNameFolder(int parentId, int level) {
    var count = 0;
    for (var folder in list) {
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

  bool checkNameAlreadyExists(FolderQtdChildView folderer) {
    bool exists = false;
    for (var folder in list) {
      if (folder.level == folderer.level &&
          folder.parentId == folderer.parentId) {
        if (folder.name == folderer.name) {
          exists = true;
        }
      }
    }
    return exists;
  }

  bool checkFolderIsExpanded(int id) {
    var result = false;
    _listFoldersIsExpanded.forEach((folder, isExpanded) {
      if (folder.id == id) {
        result = isExpanded;
      }
    });
    return result;
  }

  _load(List<FolderQtdChildView> listFolderQtdChildView) {
    bool isExpanded;
    for (var folderQtdChildView in listFolderQtdChildView) {
      if (folderQtdChildView.level > 0) {
        isExpanded = false;
      } else {
        isExpanded = true;
      }
      add(folderQtdChildView, isExpanded);
    }
  }

  void addAllFolder(List<FolderQtdChildView> folders) {
    removeAllFolder();
    _load(folders);
    _countDeleted = folders;
    notifyListeners();
  }

  expanded({required int folderId}) {
    _listFoldersIsExpanded.updateAll((key, value) {
      if (key.id == folderId) return true;
      return value;
    });
    notifyListeners();
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

  notExpanded({required int folderId}) {
    _notExpandedChildrens(folderId);
    notifyListeners();
  }

  void add(FolderQtdChildView folder, bool isExpanded) {
    _listFoldersIsExpanded.addAll({folder: isExpanded});
  }

  void removeAllFolder() {
    _listFoldersIsExpanded.clear();
  }
}
