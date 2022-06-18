import 'package:safe_notes/app/shared/database/models/note_model.dart';

import 'folder_model_stub.dart';

List<NoteModel> listNotes = [
  note1,
  note2,
  note3,
  note4,
];

final note1 = NoteModel(
  folderId: folder3.folderId,
  noteId: 101,
  body: 'Body 1',
  title: 'Title 1',
  favorite: false,
  isDeleted: false,
  dateCreate: DateTime.now(),
  dateModification: DateTime.now(),
);

final note2 = NoteModel(
  folderId: folder3.folderId,
  noteId: 102,
  body: 'Body 2',
  title: 'Title 2',
  favorite: false,
  isDeleted: false,
  dateCreate: DateTime.now(),
  dateModification: DateTime.now(),
);

final note3 = NoteModel(
  folderId: folder3.folderId,
  noteId: 103,
  body: 'Body 3',
  title: 'Title 3',
  favorite: false,
  isDeleted: false,
  dateCreate: DateTime.now(),
  dateModification: DateTime.now(),
);

final note4 = NoteModel(
  folderId: folder4.folderId,
  noteId: 104,
  body: 'Body 4',
  title: 'Title 4',
  favorite: false,
  isDeleted: false,
  dateCreate: DateTime.now(),
  dateModification: DateTime.now(),
);

final note5 = NoteModel(
  folderId: folder41.folderId,
  noteId: 105,
  body: 'Body 5',
  title: 'Title 5',
  favorite: false,
  isDeleted: false,
  dateCreate: DateTime.now(),
  dateModification: DateTime.now(),
);

final note6 = NoteModel(
  folderId: folder41.folderId,
  noteId: 106,
  body: 'Body 6',
  title: 'Title 6',
  favorite: false,
  isDeleted: false,
  dateCreate: DateTime.now(),
  dateModification: DateTime.now(),
);

final note7 = NoteModel(
  folderId: folder41.folderId,
  noteId: 107,
  body: 'Body 7',
  title: 'Title 7',
  favorite: false,
  isDeleted: false,
  dateCreate: DateTime.now(),
  dateModification: DateTime.now(),
);
