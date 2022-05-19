import 'package:safe_notes/app/shared/database/entities/note_entity.dart';

abstract class INoteDatasource {
  Future<dynamic> addNote(NoteEntity entity);
  Future<dynamic> editNote(NoteEntity entity);
  Future<dynamic> deletePersistentNote(NoteEntity entity);
}
