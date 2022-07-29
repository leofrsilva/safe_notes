import 'package:safe_notes/app/shared/database/daos/folder_dao.dart';
import 'package:safe_notes/app/shared/database/default.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessBootStore {
  final FolderDAO _folderDAO;
  final String _firstBoot = 'first-boot';

  AccessBootStore(this._folderDAO);

  Future<void> updateFolderUserID(String uid) async {
    await _updateDefaultFolder(uid);
  }

  Future _updateDefaultFolder(String uid) async {
    final folder = await _folderDAO.findFolder(DefaultDatabase.folderIdDefault);
    if (folder != null) {
      var folderModel = FolderModel.fromEntity(folder);
      folderModel = folderModel.copyWith(
        userId: uid,
        folderParent: null,
        dateModification: DateTime.now(),
      );

      await _folderDAO.updateFolders([folderModel.entity]);
    }
  }

  Future<void> loadFirstBoot() async {
    final isFistBoot = await _getValueFirstBoot();
    if (isFistBoot) {
      await _createDefaultFolder();
    }
  }

  Future _createDefaultFolder() async {
    FolderModel folder = DefaultDatabase.folderDefault;
    await _folderDAO.insertFolders([folder.entity]).then((_) async {
      await _saveValueFirsBoot(isFirstBoot: false);
    }).onError((_, __) async {
      await _saveValueFirsBoot(isFirstBoot: true);
    });
  }

  Future _saveValueFirsBoot({bool isFirstBoot = false}) async {
    var shared = await SharedPreferences.getInstance();
    shared.setBool(_firstBoot, isFirstBoot);
  }

  Future<bool> _getValueFirstBoot() async {
    var shared = await SharedPreferences.getInstance();
    return shared.getBool(_firstBoot) ?? true;
  }
}
