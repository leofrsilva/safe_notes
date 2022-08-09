import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe_notes/app/shared/domain/models/usuario_model.dart';

import '../../domain/errors/register_key_failure.dart';
import '../../infra/datasources/i_save_key_datasource.dart';

class SaveKeyDatasource extends ISaveKeyDatasource {
  final FirebaseFirestore _firestore;
  SaveKeyDatasource(this._firestore);

  @override
  Future<dynamic> saveKey(UsuarioModel user, String keyText) async {
    try {
      var infoUser = await _firestore //
          .collection('usuario')
          .doc(user.docRef)
          .get();

      if (infoUser.data() != null) {
        if (infoUser.data()!.containsKey('key')) {
          return infoUser.data()!['key'];
        }
      }

      var json = user.toJson();
      json.addAll({'key': keyText});

      await _firestore
          .collection('usuario')
          .doc(user.docRef)
          .update(json)
          .catchError((error) {
        throw SaveKeyFirestoreError(
          'SaveKeyDatasource.saveKey',
          error,
          error.message,
        );
      });
      return keyText;
    } catch (error) {
      throw SaveKeyFirestoreError(
        'SaveKeyDatasource.saveKey',
        error,
        '',
      );
    }
  }
}
