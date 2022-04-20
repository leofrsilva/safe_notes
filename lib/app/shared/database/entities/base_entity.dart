import 'package:floor/floor.dart';

class BaseEntity {
  @primaryKey
  final int id;

  @ColumnInfo(name: 'date_create')
  final String dateCreate;

  @ColumnInfo(name: 'date_modification')
  final String dateModification;

  BaseEntity({
    required this.id,
    required this.dateCreate,
    required this.dateModification,
  });
}
