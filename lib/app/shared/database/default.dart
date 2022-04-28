import 'package:safe_notes/app/design/common/common.dart';

import 'models/folder_model.dart';

class DefaultDatabase {
  static const folderIdDefault = 999;

  static final colorFolderDefault = ColorPalettes.secondy.value;

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
}
