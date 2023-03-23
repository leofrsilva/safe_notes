import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/common/style/styles.dart';
import 'package:safe_notes/app/modules/setting/controllers/theme_store.dart';
import 'models/folder_model.dart';

class DefaultDatabase {
  static const folderIdDefault = 999;

  static final colorFolderDefault =
      Modular.get<ThemeStore>().brightnessDark.value
          ? Themes.darkTheme.colorScheme.inversePrimary.value
          : Themes.lightTheme.colorScheme.inversePrimary.value;

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

  static final FolderModel folderDefault = FolderModel(
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
}
