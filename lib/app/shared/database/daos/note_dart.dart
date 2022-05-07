import 'package:floor/floor.dart';

import '../entities/note_entity.dart';

@dao
abstract class NoteDAO {
  @insert
  Future<int> insertNote(NoteEntity record);

  @update
  Future<int> updateNotes(List<NoteEntity> records);

  @Query('UPDATE Note SET is_deleted = 1 WHERE id = :noteId')
  Future<void> deleteFolder(int noteId);

  @Query('UPDATE Note SET tag_id = NULL WHERE tag_id = :tagId')
  Future<void> removeTagFromNotes(int tagId);

  @Query('SELECT * FROM Note WHERE is_deleted = 0')
  Future<List<NoteEntity>> getAllNote();
}
