class UsuarioEntity {
  final String docRef;

  final String email;

  final String senha;

  final String name;

  final String genre;

  final DateTime dateBirth;

  final DateTime? dateCreate;

  final DateTime? dateModification;

  final bool logged;

  UsuarioEntity({
    required this.docRef,
    required this.email,
    required this.senha,
    required this.name,
    required this.genre,
    required this.dateBirth,
    this.dateCreate,
    this.dateModification,
    required this.logged,
  });
}
