import 'dart:async';

import 'package:flutter_triple/flutter_triple.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

import '../../domain/usecases/i_folder_usecase.dart';
import '../reactive/i_reactive_list_note.dart';
import '../reactive/reactive_list_note.dart';

class ListNotesStore extends NotifierStore<Failure, Stream<List<NoteModel>>> {
  final IReactiveListNote _reactiveList = ReactiveListNote();
  ReactiveListNote get reactiveList => _reactiveList as ReactiveListNote;

  final IGetListNotesUsecase _getListNotesUsecase;

  ListNotesStore(this._getListNotesUsecase) : super(Stream.value([]));

  void _setNotes(List<NoteModel> folders) {
    _reactiveList.addAllNotes(folders);
  }

  void getListNotes() {
    setLoading(true);
    final either = _getListNotesUsecase.call();
    either.fold(
      (failure) => setError(failure),
      (stream) async {
        stream.listen(_setNotes);
        update(stream);
      },
    );
    setLoading(false);
  }
}
