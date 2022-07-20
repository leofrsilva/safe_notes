import 'package:floor/floor.dart';

import '../entities/note_entity.dart';

@dao
abstract class NoteDAO {
  @insert
  Future<int> insertNote(NoteEntity record);

  @update
  Future<int> updateNotes(List<NoteEntity> records);

  @delete
  Future<int> deletePersistentNotes(List<NoteEntity> records);

  @Query('SELECT * FROM Note WHERE id = :noteId')
  Future<NoteEntity?> findNote(int noteId);

  @Query('SELECT * FROM Note WHERE folder_id = :folderId')
  Future<List<NoteEntity>> getNotesByFolder(int folderId);

  @Query('UPDATE Note SET is_deleted = 1 WHERE id = :noteId')
  Future<void> deleteNote(int noteId);

  @Query('UPDATE Note SET tag_id = NULL WHERE tag_id = :tagId')
  Future<void> removeTagFromNotes(int tagId);

  @Query('SELECT * FROM Note ORDER BY id')
  Stream<List<NoteEntity>> getNotes();
}
