import 'package:safe_notes/app/design/common/extension/extension.dart';

import '../entities/note_entity.dart';

class NoteModel {
  final NoteEntity _entity;

  NoteModel.fromEntity(this._entity);

  int get folderId => _entity.folderId;

  int? get tagId => _entity.tagId;

  int get noteId => _entity.id;

  String get body => _entity.body;

  String get title => _entity.title;

  bool get isDeleted => _entity.isDeleted.toBool!;

  DateTime get dateCreate => _entity.dateCreate.toDateTime;

  DateTime get dateModification => _entity.dateModification.toDateTime;

  static int get _generaterId {
    return DateTime.now().millisecondsSinceEpoch;
  }

  NoteModel.empty()
      : _entity = NoteEntity(
          folderId: _generaterId,
          noteId: 0,
          body: '',
          title: '',
          isDeleted: 0,
          dateCreate: DateTime.now().toString(),
          dateModification: DateTime.now().toString(),
        );

  NoteModel({
    required int noteId,
    required DateTime dateCreate,
    required DateTime dateModification,
    required String body,
    required String title,
    required bool isDeleted,
    required int folderId,
    int? tagId,
  }) : _entity = NoteEntity(
          folderId: noteId == 0 ? _generaterId : noteId,
          tagId: tagId,
          noteId: noteId,
          body: body,
          title: title,
          isDeleted: isDeleted.toInt,
          dateCreate: dateCreate.toString(),
          dateModification: dateModification.toString(),
        );

  NoteModel copyWith({
    int? noteId,
    DateTime? dateCreate,
    DateTime? dateModification,
    String? body,
    String? title,
    bool? isDeleted,
    int? folderId,
    int? tagId,
  }) {
    return NoteModel(
      noteId: noteId ?? this.noteId,
      dateCreate: dateCreate ?? this.dateCreate,
      dateModification: dateModification ?? this.dateModification,
      body: body ?? this.body,
      title: title ?? this.title,
      isDeleted: isDeleted ?? this.isDeleted,
      folderId: folderId ?? this.folderId,
      tagId: tagId ?? this.tagId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'folderId': folderId,
      'noteId': noteId,
      'tagId': tagId,
      'body': body,
      'title': title,
      'is_deleted': isDeleted,
      'date_create': dateCreate,
      'date_modification': dateModification,
    };
  }
}