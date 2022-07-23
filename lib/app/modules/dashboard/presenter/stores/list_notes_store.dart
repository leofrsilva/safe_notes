import 'dart:async';

import 'package:flutter_triple/flutter_triple.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';
import 'package:safe_notes/app/shared/errors/failure.dart';

import '../../domain/usecases/i_get_list_usecase.dart';

class ListNotesStore extends NotifierStore<Failure, Stream<List<NoteModel>>> {
  final IGetListNotesUsecase _getListNotesUsecase;

  ListNotesStore(this._getListNotesUsecase) : super(Stream.value([]));

  void getListNotes(Function(List<NoteModel>)? onListener) {
    setLoading(true);
    final either = _getListNotesUsecase.call();
    either.fold(
      (failure) => setError(failure),
      (stream) {
        stream.listen(onListener);
        update(stream);
      },
    );
    setLoading(false);
  }
}
