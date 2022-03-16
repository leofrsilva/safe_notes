import 'package:floor/floor.dart';
import 'base_entity.dart';

@Entity(
  tableName: 'Usuario',
  indices: [
    Index(value: ['email'], unique: true)
  ],
)
class UsuarioEntity extends BaseEntity {
  @ColumnInfo(name: 'email')
  final String email;

  final String name;

  @ColumnInfo(name: 'genre')
  final int genre;

  @ColumnInfo(name: 'data_birth')
  final String dateBirth;

  @ColumnInfo(name: 'logged')
  final int logged;

  UsuarioEntity({
    int? userId,
    String? dateCreate,
    String? dateModification,
    required this.dateBirth,
    required this.email,
    required this.name,
    required this.genre,
    required this.logged,
  }) : super(
          id: userId,
          dateCreate: dateCreate ?? DateTime.now().toString(),
          dateModification: dateModification ?? DateTime.now().toString(),
        );
}
