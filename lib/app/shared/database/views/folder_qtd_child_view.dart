import 'package:floor/floor.dart';

@DatabaseView(
  '''
    SELECT 
      F.id,
      F.name,
      F.level, 
      F.color,
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
  final String name;
  final int level;
  final int color;
  final int qtd;

  FolderQtdChildView({
    this.parentId,
    required this.id,
    required this.name,
    required this.level,
    required this.color,
    required this.qtd,
  });
}
