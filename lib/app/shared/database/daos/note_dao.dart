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

  @Query('''
    SELECT 
      Note.id,
      Note.title,
      Note.body,
      Note.tag_id,
      Note.folder_id,
      Note.is_deleted,
      Note.date_create,
      Note.date_modification
    FROM Note Inner JOIN Folder 
              on (Note.folder_id = Folder.id 
              and Folder.is_deleted = 0)
    WHERE Note.is_deleted = 1
   ''')
  Future<List<NoteEntity>> getNotesDeleted();
}
