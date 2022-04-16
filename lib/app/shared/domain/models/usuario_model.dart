import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/usuario_entity.dart';

class UsuarioModel extends UsuarioEntity {
  static int get qtdCharactersName => 60;
  static int get qtdCharactersEmail => 45;
  static int get qtdCharactersSenha => 10;

  UsuarioModel({
    required String docRef,
    required String email,
    required String senha,
    required String name,
    required String genre,
    required DateTime dateBirth,
    DateTime? dateCreate,
    DateTime? dateModification,
    required bool logged,
  }) : super(
          docRef: docRef,
          email: email,
          senha: senha,
          genre: genre,
          name: name,
          logged: logged,
          dateBirth: dateBirth,
          dateCreate: dateCreate,
          dateModification: dateModification,
        );

  UsuarioModel.fromEntity(UsuarioEntity entity)
      : super(
          docRef: entity.docRef,
          name: entity.name,
          genre: entity.genre,
          email: entity.email,
          senha: entity.senha,
          logged: entity.logged,
          dateCreate: entity.dateCreate,
          dateModification: entity.dateModification,
          dateBirth: entity.dateBirth,
        );

  UsuarioModel.empty()
      : super(
          docRef: '',
          name: '',
          genre: '',
          email: '',
          senha: '',
          logged: false,
          dateBirth: DateTime.now(),
          dateCreate: null,
          dateModification: null,
        );

  UsuarioModel copyWith({
    String? docRef,
    String? email,
    String? senha,
    String? name,
    String? genre,
    DateTime? dateBirth,
    DateTime? dateCreate,
    DateTime? dateModification,
    bool? logged,
  }) {
    return UsuarioModel(
      docRef: docRef ?? this.docRef,
      name: name ?? this.name,
      genre: genre ?? this.genre,
      email: email ?? this.email,
      senha: senha ?? this.senha,
      logged: logged ?? this.logged,
      dateBirth: dateBirth ?? this.dateBirth,
      dateCreate: dateCreate ?? this.dateCreate,
      dateModification: dateModification ?? this.dateModification,
    );
  }

  UsuarioModel.fromJson(Map<String, dynamic> json)
      : super(
          senha: '',
          docRef: '',
          name: json['name'],
          email: json['email'],
          genre: json['genre'],
          dateBirth: (json['date_birth'] as Timestamp).toDate(),
          dateCreate: (json['date_create'] as Timestamp).toDate(),
          dateModification: (json['date_modification'] as Timestamp).toDate(),
          logged: json['logged'],
        );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'genre': genre,
      'date_birth': dateBirth,
      'date_create': dateCreate ?? DateTime.now(),
      'date_modification': dateModification ?? DateTime.now(),
      //? 'date_modification': DateTime.now(),
      'logged': logged,
    };
  }
}
