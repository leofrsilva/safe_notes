import 'package:floor/floor.dart';

import 'base_entity.dart';

@Entity(
  tableName: 'Tag',
  indices: [
    Index(value: ['name'], unique: true),
    Index(value: ['color'], unique: true),
  ],
)
class TagEntity extends BaseEntity {
  final String name;

  final String description;

  final String color;

  TagEntity({
    required int tagId,
    required String dateCreate,
    required String dateModification,
    required this.name,
    required this.description,
    required this.color,
  }) : super(
          id: tagId,
          dateCreate: dateCreate,
          dateModification: dateModification,
        );
}
