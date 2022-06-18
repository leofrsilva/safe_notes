import '../../../domain/usecases/note/i_note_usecases.dart';
import 'stores/scroll_in_top_store.dart';

class DeletedNoteController {
  final ScrollInTopStore scrollInTopStore;
  final IRestoreNoteUsecase _restoreNoteUsecase;
  final IDeleteNotePersistentUsecase _deleteNotePersistentUsecase;

  DeletedNoteController(
    this.scrollInTopStore,
    this._restoreNoteUsecase,
    this._deleteNotePersistentUsecase,
  );
}
