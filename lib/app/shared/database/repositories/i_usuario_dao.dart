import 'package:floor/floor.dart';
import '../entities/base_entity.dart';

abstract class IUsuarioDAO<Table extends BaseEntity> {
  @insert
  Future<int> insertElement(Table recrord);
}
