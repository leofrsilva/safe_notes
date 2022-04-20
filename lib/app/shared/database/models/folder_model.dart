import 'package:safe_notes/app/design/common/extension/extension.dart';

import '../entities/folder_entity.dart';

class FolderModel {
  final FolderEntity _entity;

  FolderEntity get entity => _entity;

  String get userId => _entity.userId;

  int get folderId => _entity.id;

  int get parentId => _entity.folderParent ?? 0;

  int get level => _entity.level;

  String get name => _entity.name;

  String get color => _entity.color;

  bool get isDeleted => _entity.isDeleted.toBool ?? false;

  DateTime get dateCreate => _entity.dateCreate.toDateTime;

  DateTime get dateModification => _entity.dateModification.toDateTime;

  FolderModel.fromEntity(this._entity);

  FolderModel.empty()
      : _entity = FolderEntity(
          folderId: 0,
          userId: '',
          folderParent: null,
          level: 0,
          name: '',
          color: '',
          isDeleted: ''.toInt,
          dateCreate: DateTime.now().toString(),
          dateModification: DateTime.now().toString(),
        );

  FolderModel({
    required int folderId,
    required DateTime dateCreate,
    required DateTime dateModification,
    required String userId,
    required int folderParent,
    required int level,
    required String name,
    required String color,
    required bool isDeleted,
  }) : _entity = FolderEntity(
          folderId: folderId,
          userId: userId,
          folderParent: folderParent,
          level: level,
          name: name,
          color: color,
          isDeleted: isDeleted.toInt,
          dateCreate: dateCreate.toString(),
          dateModification: dateModification.toString(),
        );

  FolderModel copyWith({
    int? folderId,
    DateTime? dateCreate,
    DateTime? dateModification,
    String? userId,
    int? folderParent,
    int? level,
    String? name,
    String? color,
    bool? isDeleted,
  }) {
    return FolderModel(
      folderId: folderId ?? this.folderId,
      dateCreate: dateCreate ?? this.dateCreate,
      dateModification: dateModification ?? this.dateModification,
      userId: userId ?? this.userId,
      folderParent: folderParent ?? parentId,
      level: level ?? this.level,
      name: name ?? this.name,
      color: color ?? this.color,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
