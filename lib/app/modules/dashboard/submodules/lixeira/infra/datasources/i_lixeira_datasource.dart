import 'package:safe_notes/app/shared/database/entities/note_entity.dart';

abstract class ILixeiraDatasource {
  Future<List<NoteEntity>> getNotesDeleted();
}
