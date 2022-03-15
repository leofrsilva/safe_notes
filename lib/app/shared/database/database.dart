import 'package:floor/floor.dart';

@Entity(
  tableName: 'person',
  indices: [
    Index(value: ['custom_name'], unique: true)
  ],
)
class Person {
  @primaryKey
  final int id;

  @ColumnInfo()
  final String name;

  Person(this.id, this.name);
}
