abstract class IUsuarioModel {
  int get userId;
  String get name;
  String get email;
  String get genre;
  DateTime get dateBirth;
  DateTime get dateCreate;
  DateTime get dateModification;
  bool get logged;
} 

  // UsuarioEntity({
  //   int? userId,
  //   String? dateCreate,
  //   String? dateModification,
  //   required this.dateBirth,
  //   required this.email,
  //   required this.name,
  //   required String genre,
  //   required this.logged,
  // })  : codeUnitGenre = genre.toInt,
  //       // loggedInInt = logged,
  //       super(
  //         id: userId,
  //         dateCreate: dateCreate ?? DateTime.now().toString(),
  //         dateModification: dateModification ?? DateTime.now().toString(),
  //       );

  // String get genre => codeUnitGenre.toChar;

  // DateTime get dateBirthToDate => dateBirth.toDateTime;

  // bool get isLogged => logged.toBool ?? false;
  
  // UsuarioEntity copyWith({
  //   int? userId,
  //   DateTime? dateCreate,
  //   DateTime? dateModification,
  //   String? email,
  //   String? name,
  //   String? genre,
  //   DateTime? dateBirth,
  //   bool? logged,
  // }) {
  //   return UsuarioEntity(
  //     userId: userId ?? id,
  //     dateCreate: dateCreate?.toString() ?? this.dateCreate,
  //     dateModification: dateModification?.toString() ?? this.dateModification,
  //     email: email ?? this.email,
  //     name: name ?? this.name,
  //     genre: genre ?? this.genre,
  //     dateBirth: dateBirth?.toString() ?? this.dateBirth,
  //     logged: logged?.toInt ?? this.logged,
  //   );
  // }