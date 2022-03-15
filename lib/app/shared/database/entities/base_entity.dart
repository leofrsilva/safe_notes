import 'package:floor/floor.dart';
import '../../../design/common/extension/extension.dart';

class BaseEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: 'date_create')
  final String _dateCreate;

  @ColumnInfo(name: 'date_modification')
  final String _dateModification;

  BaseEntity({
    this.id,
    required String dateCreate,
    required String dateModification,
  })  : _dateCreate = dateCreate,
        _dateModification = dateModification;

  DateTime get dateCreate => _dateCreate.toDateTime;

  DateTime get dateModification => _dateModification.toDateTime;
}
