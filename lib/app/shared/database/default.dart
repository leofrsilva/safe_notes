import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';

import 'models/folder_model.dart';

class DefaultDatabase {
  static const folderIdDefault = 999;

  static final colorFolderDefault = ColorPalettes.secondy.value;

  static final listColors = <int>[
    colorFolderDefault,
    0xFF6FFE2D,
    0xFF3C5093,
    0xFF41BA41,
    0xFFAB5C78,
    0xFFC84737,
    0xFFD86534,
    0xFF93AD85,
    0xFF24E41D,
    0xFF9FD956,
    0xFF2DB0F5,
    0xFFD0B84F,
  ];

  static FolderModel get folderDefault => FolderModel(
        level: 0,
        folderParent: null,
        folderId: folderIdDefault,
        userId: '',
        name: 'Pastas',
        isDeleted: false,
        color: colorFolderDefault,
        dateCreate: DateTime.now(),
        dateModification: DateTime.now(),
      );

  static FolderQtdChildView get folderQtdChildViewDefault => FolderQtdChildView(
        id: folderIdDefault,
        qtd: 0,
        level: 0,
        isDeleted: 0,
        name: 'Pastas',
        color: colorFolderDefault,
        parentId: null,
      );
}
