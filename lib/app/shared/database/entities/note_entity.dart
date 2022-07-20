import 'package:floor/floor.dart';

import 'base_entity.dart';
import 'folder_entity.dart';
import 'tag_entity.dart';

@Entity(
  tableName: 'Note',
  foreignKeys: [
    ForeignKey(
      childColumns: ['tag_id'],
      parentColumns: ['id'],
      entity: TagEntity,
    ),
    ForeignKey(
      childColumns: ['folder_id'],
      parentColumns: ['id'],
      entity: FolderEntity,
    ),
  ],
)
class NoteEntity extends BaseEntity {
  final String title;

  final String body;

  final int favorite;

  @ColumnInfo(name: 'tag_id')
  final int? tagId;

  @ColumnInfo(name: 'folder_id')
  final int folderId;

  @ColumnInfo(name: 'is_deleted')
  final int isDeleted;

  @ColumnInfo(name: 'date_deletion')
  final String? dateDeletion; 

  NoteEntity({
    required int noteId,
    required String dateCreate,
    required String dateModification,
    required this.title,
    required this.body,
    required this.favorite,
    required this.folderId,
    required this.isDeleted,
    this.dateDeletion,
    this.tagId,
  }) : super(
          id: noteId,
          dateCreate: dateCreate,
          dateModification: dateModification,
        );
}
