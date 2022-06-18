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

  @Query('''
    SELECT Note.id,
           Note.title,
           Note.body,
           Note.tag_id,
           Note.favorite,
           Note.folder_id,
           Note.is_deleted,
           Note.date_create,
           Note.date_modification
    FROM Note INNER JOIN Folder 
              on (Note.folder_id = Folder.id 
              AND Folder.is_deleted = 0)
   ''')
  Stream<List<NoteEntity>> getNotes();
}
