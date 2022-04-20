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

  final String name;

  final String color;

  @ColumnInfo(name: 'is_deleted')
  final int isDeleted;

  FolderEntity({
    required int folderId,
    required String dateCreate,
    required String dateModification,
    //
    this.folderParent,
    required this.userId,
    required this.level,
    required this.name,
    required this.color,
    required this.isDeleted,
  }) : super(
          id: folderId,
          dateCreate: dateCreate,
          dateModification: dateModification,
        );
}
