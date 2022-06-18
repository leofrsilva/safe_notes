import 'dart:async';

import 'package:flutter_triple/flutter_triple.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

import '../../domain/usecases/i_get_list_usecase.dart';

class ListFoldersStore
    extends NotifierStore<Failure, Stream<List<FolderModel>>> {
  final IGetListFoldersUsecase _getListFoldersUsecase;

  ListFoldersStore(
    this._getListFoldersUsecase,
  ) : super(Stream.value([]));

  void getListFolders(Function(List<FolderModel>)? onListener) {
    setLoading(true);
    final either = _getListFoldersUsecase.call();
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
