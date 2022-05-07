import 'package:floor/floor.dart';

@DatabaseView(
  '''
    SELECT 
      F.id,
      F.name,
      F.level, 
      F.color,
      F.is_deleted AS isDeleted,
      F.folder_parent AS parentId,  
      (SELECT COUNT(id) 
       FROM Folder 
       WHERE (level = F.level + 1) AND
             (folder_parent = F.id)  
      ) 
      +
      (SELECT COUNT(id) 
       FROM Note 
       WHERE (folder_id = F.id) 
      )
      as qtd
    FROM Folder F
    GROUP BY id
  ''',
  viewName: 'FolderQtdChild',
)
class FolderQtdChildView {
  final int? parentId;
  final int id;
  final int qtd;
  final int level;
  final int color;
  final String name;
  final int isDeleted;

  FolderQtdChildView({
    this.parentId,
    required this.id,
    required this.qtd,
    required this.name,
    required this.level,
    required this.color,
    required this.isDeleted,
  });

  FolderQtdChildView copyWith({
    int? parentId,
    int? isDeleted,
    String? name,
    int? level,
    int? color,
    int? qtd,
    int? id,
  }) {
    return FolderQtdChildView(
      isDeleted: isDeleted ?? this.isDeleted,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      level: level ?? this.level,
      color: color ?? this.color,
      qtd: qtd ?? this.qtd,
      id: id ?? this.id,
    );
  }
}
