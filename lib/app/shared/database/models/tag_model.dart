import 'package:safe_notes/app/design/common/extension/extension.dart';

import '../entities/tag_entity.dart';

class TagModel {
  final TagEntity _entity;

  TagEntity get entity => _entity;

  int get tagId => _entity.id;

  String get name => _entity.name;

  String get description => _entity.description;

  String get color => _entity.color;

  DateTime get dateCreate => _entity.dateCreate.toDateTime;

  DateTime get dateModification => _entity.dateModification.toDateTime;

  TagModel.fromEntity(this._entity);

  TagModel.empty()
      : _entity = TagEntity(
            tagId: 0,
            name: '',
            color: '',
            description: '',
            dateCreate: '',
            dateModification: '');

  TagModel({
    required int tagId,
    required DateTime dateCreate,
    required DateTime dateModification,
    required String name,
    required String description,
    required String color,
  }) : _entity = TagEntity(
          tagId: tagId,
          name: name,
          color: color,
          description: description,
          dateCreate: dateCreate.toString(),
          dateModification: dateModification.toString(),
        );

  TagModel copyWith({
    int? tagId,
    DateTime? dateCreate,
    DateTime? dateModification,
    String? name,
    String? color,
    String? description,
  }) {
    return TagModel(
      tagId: tagId ?? this.tagId,
      dateCreate: dateCreate ?? this.dateCreate,
      dateModification: dateModification ?? this.dateModification,
      name: name ?? this.name,
      color: color ?? this.color,
      description: description ?? this.description,
    );
  }
}
