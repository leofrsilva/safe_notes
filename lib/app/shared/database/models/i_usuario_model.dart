import '../entities/usuario_entity.dart';

abstract class IUsuarioModel {
  int get userId;
  String get name;
  String get email;
  String get genre;
  DateTime get dateBirth;
  DateTime get dateCreate;
  DateTime get dateModification;
  bool get logged;

  UsuarioEntity get entity;
}
