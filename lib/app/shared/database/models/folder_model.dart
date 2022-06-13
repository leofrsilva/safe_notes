import 'package:safe_notes/app/design/common/extension/extension.dart';

import '../entities/folder_entity.dart';

class FolderModel {
  final FolderEntity _entity;

  FolderEntity get entity => _entity;

  String get userId => _entity.userId;

  int get folderId => _entity.id;

  int? get folderParent => _entity.folderParent;

  int get level => _entity.level;

  int get color => _entity.color;

  String get name => _entity.name;

  bool get isDeleted => _entity.isDeleted.toBool!;

  DateTime get dateCreate => _entity.dateCreate.toDateTime;

  DateTime get dateModification => _entity.dateModification.toDateTime;

  FolderModel.fromEntity(this._entity);

  static int get _generaterId {
    return DateTime.now().millisecondsSinceEpoch;
  }

  FolderModel.empty()
      : _entity = FolderEntity(
          folderId: _generaterId,
          userId: '',
          level: 0,
          name: '',
          color: 0,
          isDeleted: 0,
          dateCreate: DateTime.now().toString(),
          dateModification: DateTime.now().toString(),
        );

  FolderModel({
    int? folderParent,
    required int folderId,
    required DateTime dateCreate,
    required DateTime dateModification,
    required String userId,
    required int level,
    required int color,
    required String name,
    required bool isDeleted,
  }) : _entity = FolderEntity(
          folderId: folderId == 0 ? _generaterId : folderId,
          folderParent: folderParent,
          userId: userId,
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
    int? color,
    String? name,
    bool? isDeleted,
  }) {
    return FolderModel(
      folderParent: folderParent ?? this.folderParent,
      folderId: folderId ?? this.folderId,
      userId: userId ?? this.userId,
      level: level ?? this.level,
      name: name ?? this.name,
      color: color ?? this.color,
      isDeleted: isDeleted ?? this.isDeleted,
      dateCreate: dateCreate ?? this.dateCreate,
      dateModification: dateModification ?? this.dateModification,
    );
  }

  static List<FolderModel> fromListEntity(List<FolderEntity> entities) {
    return entities.map((entity) => FolderModel.fromEntity(entity)).toList();
  }

  factory FolderModel.fromJson(Map<String, dynamic> json) {
    return FolderModel(
      folderId: json['id'],
      folderParent: json['folder_parent'],
      userId: json['user_id'],
      level: json['level'],
      name: json['name'],
      color: json['color'],
      isDeleted: json['is_deleted'] as bool,
      dateCreate: DateTime.parse(json['date_create']),
      dateModification: DateTime.parse(json['date_modification'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': folderId,
      'folder_parent': folderParent,
      'user_id': userId,
      'level': level,
      'name': name,
      'color': color,
      'is_deleted': isDeleted,
      'date_create': dateCreate.toString(),
      'date_modification': dateModification.toString(),
    };
  }
}
