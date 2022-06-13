import 'dart:async';
import 'package:safe_notes/app/shared/database/models/note_model.dart';

class InputFieldNoteStore {
  NoteModel model = NoteModel.empty();

  nowDateModification() {
    model = model.copyWith(dateModification: DateTime.now());
  }

  set folderId(int id) {
    model = model.copyWith(folderId: id);
  }

  set title(String title) {
    model = model.copyWith(title: title);
  }

  set body(String body) {
    model = model.copyWith(body: body);
  }

  onChangeFavorite(Function callback) {
    model = model.copyWith(favorite: !model.favorite);
    callback.call();
  }

  Timer? _debounceTitle;

  onChangedTitle(String text, {required Function callback}) {
    if (_debounceTitle?.isActive ?? false) _debounceTitle!.cancel();
    _debounceTitle = Timer(const Duration(milliseconds: 500), () {
      title = text.trim();
      callback.call();
    });
  }

  Timer? _debounceBody;

  onChangedBody(String text, {required Function callback}) {
    if (_debounceBody?.isActive ?? false) _debounceBody!.cancel();
    _debounceBody = Timer(const Duration(milliseconds: 500), () {
      body = text;
      callback.call();
    });
  }
}
