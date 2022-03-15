import 'package:floor/floor.dart';

class BaseEntity {
  @primaryKey
  final int id;

  @ColumnInfo(name: 'date_create')
  final String dateCreate;

  @ColumnInfo(name: 'date_modification')
  final String dateModification;

  BaseEntity(
    this.id, {
    DateTime? dateCreate,
    DateTime? dateModification,
  })  : dateModification = (dateModification ?? DateTime.now()).toString(),
        dateCreate = (dateCreate ?? DateTime.now()).toString();
}
