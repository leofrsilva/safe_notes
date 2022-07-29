import 'package:safe_notes/app/shared/database/entities/note_entity.dart';

abstract class INoteDatasource {
  Future<dynamic> addNotes(List<NoteEntity> entities);
  Future<dynamic> editNote(List<NoteEntity> entities);
  Future<dynamic> deleteNote(List<NoteEntity> entities);
  Future<dynamic> restoreNote(List<NoteEntity> entities);
  Future<dynamic> deletePersistentNote(List<NoteEntity> entities);
}
