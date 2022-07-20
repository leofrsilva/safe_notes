import 'package:floor/floor.dart';

import 'base_entity.dart';

@Entity(
  tableName: 'Folder',
  foreignKeys: [
    ForeignKey(
      childColumns: ['folder_parent'],
      parentColumns: ['id'],
      entity: FolderEntity,
    ),
  ],
)
class FolderEntity extends BaseEntity {
  @ColumnInfo(name: 'folder_parent')
  final int? folderParent;

  @ColumnInfo(name: 'user_id')
  final String userId;

  final int level;

  final int color;

  final String name;

  @ColumnInfo(name: 'is_deleted')
  final int isDeleted;

  @ColumnInfo(name: 'date_deletion')
  final String? dateDeletion;

  FolderEntity({
    required int folderId,
    required String dateCreate,
    required String dateModification,
    required this.userId,
    required this.level,
    required this.name,
    required this.color,
    required this.isDeleted,
    this.dateDeletion,
    this.folderParent,
  }) : super(
          id: folderId,
          dateCreate: dateCreate,
          dateModification: dateModification,
        );
}
