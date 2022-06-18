import 'package:safe_notes/app/shared/database/models/folder_model.dart';

List<FolderModel> listFolders = [
  folder,
  folder1,
  folder11,
  folder111,
  folder1111,
  folder2,
  folder21,
  folder22,
  folder221,
  folder3,
  folder4,
  folder41,
  folder42,
];

final folder = FolderModel(
  folderParent: null,
  level: 0,
  folderId: 100,
  userId: 'docRef',
  name: 'Pasta',
  color: 0xFF28EDDA,
  isDeleted: false,
  dateCreate: DateTime.now(),
  dateModification: DateTime.now(),
);

final folder1 = FolderModel(
  folderParent: 100,
  level: 1,
  folderId: 101,
  userId: 'docRef',
  name: 'Pasta 1',
  color: 0xFF885599,
  isDeleted: false,
  dateCreate: DateTime.now(),
  dateModification: DateTime.now(),
);

final folder11 = FolderModel(
  folderParent: 101,
  level: 2,
  folderId: 1011,
  userId: 'docRef',
  name: 'Pasta 1 - 1',
  color: 0xFF885599,
  isDeleted: false,
  dateCreate: DateTime.now(),
  dateModification: DateTime.now(),
);

final folder111 = FolderModel(
  folderParent: 1011,
  level: 3,
  folderId: 10111,
  userId: 'docRef',
  name: 'Pasta 1 - 1 - 1',
  color: 0xFF885599,
  isDeleted: false,
  dateCreate: DateTime.now(),
  dateModification: DateTime.now(),
);

final folder1111 = FolderModel(
  folderParent: 10111,
  level: 4,
  folderId: 101111,
  userId: 'docRef',
  name: 'Pasta 1 - 1 - 1 - 1',
  color: 0xFF885599,
  isDeleted: false,
  dateCreate: DateTime.now(),
  dateModification: DateTime.now(),
);

final folder2 = FolderModel(
  folderParent: 100,
  level: 1,
  folderId: 102,
  userId: 'docRef',
  name: 'Pasta 2',
  color: 0xFF885599,
  isDeleted: false,
  dateCreate: DateTime.now(),
  dateModification: DateTime.now(),
);

final folder21 = FolderModel(
  folderParent: 102,
  level: 2,
  folderId: 1021,
  userId: 'docRef',
  name: 'Pasta 2 - 1',
  color: 0xFF885599,
  isDeleted: false,
  dateCreate: DateTime.now(),
  dateModification: DateTime.now(),
);

final folder22 = FolderModel(
  folderParent: 102,
  level: 2,
  folderId: 1022,
  userId: 'docRef',
  name: 'Pasta 2 - 2',
  color: 0xFF885599,
  isDeleted: false,
  dateCreate: DateTime.now(),
  dateModification: DateTime.now(),
);

final folder221 = FolderModel(
  folderParent: 1022,
  level: 3,
  folderId: 10221,
  userId: 'docRef',
  name: 'Pasta 2 - 2 - 1',
  color: 0xFF885599,
  isDeleted: false,
  dateCreate: DateTime.now(),
  dateModification: DateTime.now(),
);

final folder3 = FolderModel(
  folderParent: 100,
  level: 1,
  folderId: 103,
  userId: 'docRef',
  name: 'Pasta 3',
  color: 0xFF885599,
  isDeleted: false,
  dateCreate: DateTime.now(),
  dateModification: DateTime.now(),
);

final folder4 = FolderModel(
  folderParent: 100,
  level: 1,
  folderId: 104,
  userId: 'docRef',
  name: 'Pasta 4',
  color: 0xFF885599,
  isDeleted: false,
  dateCreate: DateTime.now(),
  dateModification: DateTime.now(),
);

final folder41 = FolderModel(
  folderParent: 104,
  level: 2,
  folderId: 1041,
  userId: 'docRef',
  name: 'Pasta 4 - 1',
  color: 0xFF885599,
  isDeleted: false,
  dateCreate: DateTime.now(),
  dateModification: DateTime.now(),
);

final folder42 = FolderModel(
  folderParent: 104,
  level: 2,
  folderId: 1042,
  userId: 'docRef',
  name: 'Pasta 4 - 2',
  color: 0xFF885599,
  isDeleted: false,
  dateCreate: DateTime.now(),
  dateModification: DateTime.now(),
);

final folder5 = FolderModel(
  folderParent: 100,
  level: 1,
  folderId: 105,
  userId: 'docRef',
  name: 'Pasta 5',
  color: 0xFF885599,
  isDeleted: false,
  dateCreate: DateTime.now(),
  dateModification: DateTime.now(),
);

final folder6 = FolderModel(
  folderParent: 100,
  level: 1,
  folderId: 106,
  userId: 'docRef',
  name: 'Pasta 6',
  color: 0xFF885599,
  isDeleted: false,
  dateCreate: DateTime.now(),
  dateModification: DateTime.now(),
);

final folder61 = FolderModel(
  folderParent: 106,
  level: 2,
  folderId: 1061,
  userId: 'docRef',
  name: 'Pasta 6 - 1',
  color: 0xFF885599,
  isDeleted: false,
  dateCreate: DateTime.now(),
  dateModification: DateTime.now(),
);

final folder611 = FolderModel(
  folderParent: 1061,
  level: 3,
  folderId: 106111,
  userId: 'docRef',
  name: 'Pasta 6 - 1 - 1',
  color: 0xFF885599,
  isDeleted: false,
  dateCreate: DateTime.now(),
  dateModification: DateTime.now(),
);

final folder7 = FolderModel(
  folderParent: 100,
  level: 1,
  folderId: 107,
  userId: 'docRef',
  name: 'Pasta 7',
  color: 0xFF885599,
  isDeleted: false,
  dateCreate: DateTime.now(),
  dateModification: DateTime.now(),
);

final folder8 = FolderModel(
  folderParent: 100,
  level: 1,
  folderId: 108,
  userId: 'docRef',
  name: 'Pasta 8',
  color: 0xFF885599,
  isDeleted: false,
  dateCreate: DateTime.now(),
  dateModification: DateTime.now(),
);

final folder9 = FolderModel(
  folderParent: 100,
  level: 1,
  folderId: 109,
  userId: 'docRef',
  name: 'Pasta 9',
  color: 0xFF885599,
  isDeleted: false,
  dateCreate: DateTime.now(),
  dateModification: DateTime.now(),
);

final folder91 = FolderModel(
  folderParent: 109,
  level: 1,
  folderId: 1091,
  userId: 'docRef',
  name: 'Pasta 9 - 1',
  color: 0xFF885599,
  isDeleted: false,
  dateCreate: DateTime.now(),
  dateModification: DateTime.now(),
);

final folder10 = FolderModel(
  folderParent: 100,
  level: 1,
  folderId: 1010,
  userId: 'docRef',
  name: 'Pasta 10',
  color: 0xFF885599,
  isDeleted: false,
  dateCreate: DateTime.now(),
  dateModification: DateTime.now(),
);
