import 'package:floor/floor.dart';

class BaseEntity {
  @primaryKey
  final int id;

  @ColumnInfo(name: 'date_create')
  final String dateCreate;

  BaseEntity(
    this.id, {
    String? dateCreate,
  }) : dateCreate = dateCreate ?? DateTime.now().toString();
}
