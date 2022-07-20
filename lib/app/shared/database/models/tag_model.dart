import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/common/extension/extension.dart';
import 'package:safe_notes/app/shared/encrypt/data_encrypt.dart';

import '../entities/tag_entity.dart';

class TagModel {
  late DataEncrypt _encrypt;

  late TagEntity _entity;
  TagEntity get entity => _entity;

  int get tagId => _entity.id;

  int get color => _entity.color;

  String get name => _encrypt.decode(_entity.name);

  String get description => _encrypt.decode(_entity.description ?? '');

  bool get isDeleted => _entity.isDeleted.toBool!;

  DateTime get dateCreate => _entity.dateCreate.toDateTime;

  DateTime get dateModification => _entity.dateModification.toDateTime;

  static int get _generaterId {
    return DateTime.now().millisecondsSinceEpoch;
  }

  TagModel.fromEntity(this._entity) : _encrypt = Modular.get<DataEncrypt>();

  TagModel.empty()
      : _encrypt = Modular.get<DataEncrypt>(),
        _entity = TagEntity(
          tagId: _generaterId,
          name: '',
          color: 0,
          isDeleted: 0,
          dateCreate: DateTime.now().toString(),
          dateModification: DateTime.now().toString(),
        );

  TagModel({
    required int tagId,
    required DateTime dateCreate,
    required DateTime dateModification,
    required String name,
    required int color,
    required bool isDeleted,
    String? description,
  }) {
    _encrypt = Modular.get<DataEncrypt>();
    _entity = TagEntity(
      tagId: tagId == 0 ? _generaterId : tagId,
      name: _encrypt.encode(name),
      color: color,
      description: _encrypt.encode(description ?? ''),
      isDeleted: isDeleted.toInt,
      dateCreate: dateCreate.toString(),
      dateModification: dateModification.toString(),
    );
  }

  TagModel copyWith({
    int? tagId,
    DateTime? dateCreate,
    DateTime? dateModification,
    String? description,
    String? name,
    int? color,
    bool? isDeleted,
  }) {
    return TagModel(
      tagId: tagId ?? this.tagId,
      dateCreate: dateCreate ?? this.dateCreate,
      dateModification: dateModification ?? this.dateModification,
      name: name ?? this.name,
      color: color ?? this.color,
      isDeleted: isDeleted ?? this.isDeleted,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': tagId,
      'name': name,
      'color': color,
      'description': description,
      'is_deleted': isDeleted,
      'date_create': dateCreate,
      'date_modification': dateModification,
    };
  }
}
