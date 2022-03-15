import 'package:floor/floor.dart';

import 'base_entity.dart';
import '../../../design/common/extension/extension.dart';

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
  final int _genre;

  @ColumnInfo(name: 'data_birth')
  final String _dataBirth;

  @ColumnInfo(name: 'logged')
  final int _logged;

  UsuarioEntity({
    int? userId,
    String? dateCreate,
    String? dateModification,
    required this.email,
    required this.name,
    required String genre,
    required DateTime dataBirth,
    required bool logged,
  })  : _genre = genre.toInt,
        _dataBirth = dataBirth.toString(),
        _logged = logged.toInt,
        super(
          id: userId,
          dateCreate: dateCreate ?? DateTime.now().toString(),
          dateModification: dateModification ?? DateTime.now().toString(),
        );

  String get genre => _genre.toChar;

  DateTime get dataBirth => _dataBirth.toDateTime;

  bool get logged => _logged.toBool ?? false;

  UsuarioEntity copyWith({
    int? userId,
    String? dateCreate,
    String? dateModification,
    String? email,
    String? name,
    String? genre,
    DateTime? dataBirth,
    bool? logged,
  }) {
    return UsuarioEntity(
      userId: userId ?? id,
      dateCreate: dateCreate ?? this.dateCreate.toString(),
      dateModification: dateModification ?? this.dateModification.toString(),
      email: email ?? this.email,
      name: name ?? this.name,
      genre: genre ?? _genre.toChar,
      dataBirth: dataBirth ?? _dataBirth.toDateTime,
      logged: logged ?? _logged.toBool!,
    );
  }
}
