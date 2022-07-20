import 'package:safe_notes/app/design/common/extension/extension.dart';

import '../entities/note_entity.dart';

class NoteModel {
  final NoteEntity _entity;

  NoteEntity get entity => _entity;

  NoteModel.fromEntity(this._entity);

  int get folderId => _entity.folderId;

  int? get tagId => _entity.tagId;

  int get noteId => _entity.id;

  String get body => _entity.body;

  String get title => _entity.title;

  bool get favorite => _entity.favorite.toBool!;

  bool get isDeleted => _entity.isDeleted.toBool!;

  DateTime? get dateDeletion => _entity.dateDeletion?.toDateTime;

  int get deletionExpiration {
    int expiration = 0;
    if (dateDeletion != null) {
      DateTime dateExecuteDeletion = dateDeletion!.add(
        const Duration(days: 30),
      );
      Duration timeDifference = dateExecuteDeletion.difference(DateTime.now());

      if (timeDifference.inMinutes < 1) {
        expiration = -1;
      } else {
        expiration = timeDifference.inDays == 0 ? 1 : timeDifference.inDays;
      }
    }
    return expiration;
  }

  DateTime get dateCreate => _entity.dateCreate.toDateTime;

  DateTime get dateModification => _entity.dateModification.toDateTime;

  static int get _generaterId {
    return DateTime.now().millisecondsSinceEpoch;
  }

  NoteModel.empty()
      : _entity = NoteEntity(
          noteId: _generaterId,
          folderId: 0,
          body: '',
          title: '',
          favorite: 0,
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
    required int folderId,
    required bool favorite,
    required bool isDeleted,
    DateTime? dateDeletion,
    int? tagId,
  }) : _entity = NoteEntity(
          folderId: folderId == 0 ? _generaterId : folderId,
          tagId: tagId,
          noteId: noteId,
          body: body,
          title: title,
          favorite: favorite.toInt,
          isDeleted: isDeleted.toInt,
          dateDeletion: dateDeletion?.toString(),
          dateCreate: dateCreate.toString(),
          dateModification: dateModification.toString(),
        );

  NoteModel copyWith({
    int? noteId,
    DateTime? dateCreate,
    DateTime? dateModification,
    int? tagId,
    String? body,
    String? title,
    bool? favorite,
    int? folderId,
    bool? isDeleted,
    DateTime? dateDeletion,
  }) {
    return NoteModel(
      noteId: noteId ?? this.noteId,
      dateCreate: dateCreate ?? this.dateCreate,
      dateModification: dateModification ?? this.dateModification,
      body: body ?? this.body,
      title: title ?? this.title,
      favorite: favorite ?? this.favorite,
      folderId: folderId ?? this.folderId,
      isDeleted: isDeleted ?? this.isDeleted,
      dateDeletion: dateDeletion ?? this.dateDeletion,
      tagId: tagId ?? this.tagId,
    );
  }

  static List<NoteModel> fromListEntity(List<NoteEntity> entities) {
    return entities.map((entity) => NoteModel.fromEntity(entity)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'folderId': folderId,
      'noteId': noteId,
      'tagId': tagId,
      'body': body,
      'title': title,
      'favorite': favorite,
      'is_deleted': isDeleted,
      'date_deletion': dateDeletion,
      'date_create': dateCreate,
      'date_modification': dateModification,
    };
  }
}
