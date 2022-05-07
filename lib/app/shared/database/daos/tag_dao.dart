import 'package:floor/floor.dart';

import '../entities/tag_entity.dart';

@dao
abstract class TagDAO {
  @insert
  Future<int> insertTag(TagEntity record);

  @update
  Future<int> updateTags(List<TagEntity> records);

  @Query('UPDATE Tag SET is_deleted = 1 WHERE id = :tagId')
  Future<void> deleteTag(int tagId);

  @Query('SELECT * FROM Tag')
  Future<List<TagEntity>> getAllTag();
}
