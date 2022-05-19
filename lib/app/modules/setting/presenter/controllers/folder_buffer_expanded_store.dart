import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FolderBufferExpandedStore {
  final String _keyBuffer = 'buff-expanded';

  Map<String, bool> _adapterMapToJson(Map<int, bool> map) {
    return map.map<String, bool>(
      (id, isExpanded) => MapEntry('$id', isExpanded),
    );
  }

  Map<int, bool> _adapterJsonToMap(Map<String, dynamic> map) {
    return map.map<int, bool>(
      (id, isExpanded) => MapEntry(int.parse(id), isExpanded),
    );
  }

  Future setBufferExpanded(Map<int, bool> map) async {
    final strBufferExpanded = jsonEncode(_adapterMapToJson(map));
    await _saveValueBufferExpanded(bufferExpanded: strBufferExpanded);
  }

  Future<Map<int, bool>> getBufferExpanded() async {
    final strBufferExpanded = await _getValueBufferExpanded();
    return strBufferExpanded.isNotEmpty
        ? _adapterJsonToMap(jsonDecode(strBufferExpanded))
        : {};
  }

  Future _saveValueBufferExpanded({String bufferExpanded = ''}) async {
    var shared = await SharedPreferences.getInstance();
    shared.setString(_keyBuffer, bufferExpanded);
  }

  Future<String> _getValueBufferExpanded() async {
    var shared = await SharedPreferences.getInstance();
    return shared.getString(_keyBuffer) ?? '';
  }
}
