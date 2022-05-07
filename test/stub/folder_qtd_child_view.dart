import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';

List<FolderQtdChildView> listfolderQtsChild = [
  folderQtsChild,
  folderQtsChild1,
  folderQtsChild11,
  folderQtsChild111,
  folderQtsChild1111,
  folderQtsChild2,
  folderQtsChild21,
  folderQtsChild22,
  folderQtsChild221,
  folderQtsChild3,
  folderQtsChild4,
  folderQtsChild41,
  folderQtsChild42,
];

final folderQtsChild = FolderQtdChildView(
  parentId: null,
  level: 0,
  id: 100,
  name: 'Pasta',
  color: 0xFF28EDDA,
  isDeleted: 0,
  qtd: 4,
);

final folderQtsChild1 = FolderQtdChildView(
  parentId: 100,
  level: 1,
  id: 101,
  name: 'Pasta 1',
  color: 0xFF885599,
  isDeleted: 0,
  qtd: 1,
);

final folderQtsChild11 = FolderQtdChildView(
  parentId: 101,
  level: 2,
  id: 1011,
  name: 'Pasta 1 - 1',
  color: 0xFF885599,
  isDeleted: 0,
  qtd: 1,
);

final folderQtsChild111 = FolderQtdChildView(
  parentId: 1011,
  level: 3,
  id: 10111,
  name: 'Pasta 1 - 1 - 1',
  color: 0xFF885599,
  isDeleted: 0,
  qtd: 1,
);

final folderQtsChild1111 = FolderQtdChildView(
  parentId: 10111,
  level: 4,
  id: 101111,
  name: 'Pasta 1 - 1 - 1 - 1',
  color: 0xFF885599,
  isDeleted: 0,
  qtd: 0,
);

final folderQtsChild2 = FolderQtdChildView(
  parentId: 100,
  level: 1,
  id: 102,
  name: 'Pasta 2',
  color: 0xFF885599,
  isDeleted: 0,
  qtd: 2,
);

final folderQtsChild21 = FolderQtdChildView(
  parentId: 102,
  level: 2,
  id: 1021,
  name: 'Pasta 2 - 1',
  color: 0xFF885599,
  isDeleted: 0,
  qtd: 0,
);

final folderQtsChild22 = FolderQtdChildView(
  parentId: 102,
  level: 2,
  id: 1022,
  name: 'Pasta 2 - 2',
  color: 0xFF885599,
  isDeleted: 0,
  qtd: 1,
);

final folderQtsChild221 = FolderQtdChildView(
  parentId: 1022,
  level: 3,
  id: 10221,
  name: 'Pasta 2 - 2 - 1',
  color: 0xFF885599,
  isDeleted: 0,
  qtd: 0,
);

final folderQtsChild3 = FolderQtdChildView(
  parentId: 100,
  level: 1,
  id: 103,
  name: 'Pasta 3',
  color: 0xFF885599,
  isDeleted: 0,
  qtd: 0,
);

final folderQtsChild4 = FolderQtdChildView(
  parentId: 100,
  level: 1,
  id: 104,
  name: 'Pasta 4',
  color: 0xFF885599,
  isDeleted: 0,
  qtd: 2,
);

final folderQtsChild41 = FolderQtdChildView(
  parentId: 104,
  level: 2,
  id: 1041,
  name: 'Pasta 4 - 1',
  color: 0xFF885599,
  isDeleted: 0,
  qtd: 0,
);

final folderQtsChild42 = FolderQtdChildView(
  parentId: 104,
  level: 2,
  id: 1042,
  name: 'Pasta 4 - 2',
  color: 0xFF885599,
  isDeleted: 0,
  qtd: 0,
);
