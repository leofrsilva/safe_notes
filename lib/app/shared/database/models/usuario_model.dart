import '../entities/usuario_entity.dart';
import '../../../design/common/extension/extension.dart';

import 'i_usuario_model.dart';

class UsuarioModel implements IUsuarioModel {
  final UsuarioEntity _entity;
  UsuarioModel(this._entity);

  @override
  UsuarioEntity get entity => _entity;

  @override
  bool get logged => _entity.logged.toBool ?? false;

  @override
  DateTime get dateCreate => _entity.dateCreate.toDateTime;

  @override
  DateTime get dateModification => _entity.dateModification.toDateTime;

  @override
  DateTime get dateBirth => _entity.dateBirth.toDateTime;

  @override
  String get genre => _entity.genre.toChar;

  @override
  String get email => _entity.email;

  @override
  String get name => _entity.name;

  @override
  int get userId => _entity.id ?? 0;

  UsuarioModel.fromEntity({
    int? userId,
    DateTime? dateCreate,
    DateTime? dateModification,
    required DateTime dateBirth,
    required String email,
    required String name,
    required String genre,
    required bool logged,
  }) : _entity = UsuarioEntity(
          userId: userId,
          email: email,
          name: name,
          genre: genre.toInt,
          logged: logged.toInt,
          dateBirth: dateBirth.toString(),
          dateCreate: (dateCreate ?? DateTime.now()).toString(),
          dateModification: (dateModification ?? DateTime.now()).toString(),
        );

  UsuarioModel copyWith({
    int? userId,
    DateTime? dateBirth,
    DateTime? dateCreate,
    DateTime? dateModification,
    String? email,
    String? name,
    String? genre,
    bool? logged,
  }) {
    return UsuarioModel.fromEntity(
      userId: userId ?? this.userId,
      dateBirth: dateBirth ?? this.dateBirth,
      dateCreate: dateCreate ?? this.dateCreate,
      dateModification: dateModification ?? this.dateModification,
      email: email ?? this.email,
      name: name ?? this.name,
      genre: genre ?? this.genre,
      logged: logged ?? this.logged,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'user_id': _entity.id,
      'name': _entity.name,
      'email': _entity.email,
      'genre': genre,
      'date_birth': dateBirth,
      'date_create': dateCreate,
      'date_modification': dateModification,
    };
  }
}
