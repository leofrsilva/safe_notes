import 'package:floor/floor.dart';

class BaseEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: 'date_create')
  final String dateCreate;

  @ColumnInfo(name: 'date_modification')
  final String dateModification;

  BaseEntity({
    this.id,
    required this.dateCreate,
    required this.dateModification,
  });
}
