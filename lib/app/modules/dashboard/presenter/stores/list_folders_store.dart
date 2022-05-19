import 'dart:async';

import 'package:flutter_triple/flutter_triple.dart';
import 'package:safe_notes/app/modules/setting/presenter/controllers/folder_buffer_expanded_store.dart';
import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

import '../../domain/usecases/i_folder_usecase.dart';
import '../reactive/i_reactive_list_folder.dart';
import '../reactive/reactive_list_folder.dart';

class ListFoldersStore
    extends NotifierStore<Failure, Stream<List<FolderQtdChildView>>> {
  final IReactiveListFolder _reactiveList = ReactiveListFolder();
  ReactiveListFolder get reactiveList => _reactiveList as ReactiveListFolder;

  final IGetListFoldersUsecase _getListFoldersUsecase;
  final FolderBufferExpandedStore _folderBufferExpandedStore;

  ListFoldersStore(
    this._getListFoldersUsecase,
    this._folderBufferExpandedStore,
  ) : super(Stream.value([])) {
    _setBuffer();
  }

  Future<void> _setBuffer() async {
    final mapIsExpanded = await _folderBufferExpandedStore.getBufferExpanded();
    reactiveList.setBufferExpanded(mapIsExpanded);
  }

  Future<void> saveBuffer(Map<int, bool> mapBufferExpanded) async {
    await _folderBufferExpandedStore.setBufferExpanded(mapBufferExpanded);
  }

  _setFolders(List<FolderQtdChildView> folders) {
    reactiveList.addAllFolder(folders);
  }

  void getListFolders() {
    setLoading(true);
    final either = _getListFoldersUsecase.call();
    either.fold(
      (failure) => setError(failure),
      (stream) async {
        stream.listen(_setFolders);
        update(stream);
      },
    );
    setLoading(false);
  }
}

// final folder = FolderQtdChildView(
//   parentId: null,
//   level: 0,
//   id: 100,
//   name: 'Pastas',
//   color: 0xFF28EDDA,
//   qtd: 4,
// );

// final folder1 = FolderQtdChildView(
//   parentId: 100,
//   level: 1,
//   id: 101,
//   name: 'Pasta 1',
//   color: 0xFF885599,
//   qtd: 1,
// );

// final folder11 = FolderQtdChildView(
//   parentId: 101,
//   level: 2,
//   id: 1011,
//   name: 'Pasta 1 - 1',
//   color: 0xFF885599,
//   qtd: 1,
// );

// final folder111 = FolderQtdChildView(
//   parentId: 1011,
//   level: 3,
//   id: 10111,
//   name: 'Pasta 1 - 1 - 1',
//   color: 0xFF885599,
//   qtd: 1,
// );

// final folder1111 = FolderQtdChildView(
//   parentId: 10111,
//   level: 4,
//   id: 101111,
//   name: 'Pasta 1 - 1 - 1 - 1',
//   color: 0xFF885599,
//   qtd: 0,
// );

// final folder2 = FolderQtdChildView(
//   parentId: 100,
//   level: 1,
//   id: 102,
//   name: 'Pasta 2',
//   color: 0xFF885599,
//   qtd: 2,
// );

// final folder21 = FolderQtdChildView(
//   parentId: 102,
//   level: 2,
//   id: 1021,
//   name: 'Pasta 2 - 1',
//   color: 0xFF885599,
//   qtd: 0,
// );

// final folder22 = FolderQtdChildView(
//   parentId: 102,
//   level: 2,
//   id: 1022,
//   name: 'Pasta 2 - 2',
//   color: 0xFF885599,
//   qtd: 1,
// );

// final folder221 = FolderQtdChildView(
//   parentId: 1022,
//   level: 3,
//   id: 10221,
//   name: 'Pasta 2 - 2 - 1',
//   color: 0xFF885599,
//   qtd: 0,
// );

// final folder3 = FolderQtdChildView(
//   parentId: 100,
//   level: 1,
//   id: 103,
//   name: 'Pasta 3',
//   color: 0xFF885599,
//   qtd: 0,
// );

// final folder4 = FolderQtdChildView(
//   parentId: 100,
//   level: 1,
//   id: 104,
//   name: 'Pasta 4',
//   color: 0xFF885599,
//   qtd: 2,
// );

// final folder41 = FolderQtdChildView(
//   parentId: 104,
//   level: 2,
//   id: 1041,
//   name: 'Pasta 4 - 1',
//   color: 0xFF885599,
//   qtd: 0,
// );

// final folder42 = FolderQtdChildView(
//   parentId: 104,
//   level: 2,
//   id: 1042,
//   name: 'Pasta 4 - 2',
//   color: 0xFF885599,
//   qtd: 0,
// );
