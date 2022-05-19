import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ManagerRouteNavigatorStore {
  final _keyRouter = 'key-router';
  final _keyFolderParent = 'key-folder-parent';

  Future savePage({String page = ''}) async {
    var shared = await SharedPreferences.getInstance();
    shared.setString(_keyRouter, page);
  }

  Future<String> getPage() async {
    var shared = await SharedPreferences.getInstance();
    return shared.getString(_keyRouter) ?? '';
  }

  Future removeFolderParent() async {
    var shared = await SharedPreferences.getInstance();
    shared.remove(_keyFolderParent);
  }

  Future saveFolderParent(Map<String, dynamic> infoFolder) async {
    var shared = await SharedPreferences.getInstance();
    final strInfoFolder = jsonEncode(infoFolder);
    shared.setString(_keyFolderParent, strInfoFolder);
  }

  Future<Map<String, dynamic>> getFolderParent() async {
    var shared = await SharedPreferences.getInstance();
    final strInfoFolder = shared.getString(_keyFolderParent) ?? '';
    return strInfoFolder.isEmpty ? {} : jsonDecode(strInfoFolder);
  }
}
