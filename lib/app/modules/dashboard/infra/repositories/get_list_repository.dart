import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';
import 'package:safe_notes/app/shared/errors/failure.dart';

import '../../domain/repositories/i_get_list_repository.dart';
import '../datasources/i_get_list_datasource.dart';

class GetListRepository extends IGetListRepository {
  final IGetListDatasource _datasource;
  GetListRepository(this._datasource);

  @override
  Either<Failure, Stream<List<FolderModel>>> getFolders() {
    try {
      final streamEntity = _datasource.getFolders();
      final streamModel = streamEntity.map<List<FolderModel>>(
        (entities) => FolderModel.fromListEntity(entities),
      );
      return Right(streamModel);
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (exception, stacktrace) {
      return Left(UnknownError(
        exception: exception,
        stackTrace: stacktrace,
        label: 'GetListRepository-getFolders',
      ));
    }
  }

  @override
  Either<Failure, Stream<List<NoteModel>>> getNotes() {
    try {
      final streamEntity = _datasource.getNotes();
      final streamModel = streamEntity.map<List<NoteModel>>(
        (entities) => NoteModel.fromListEntity(entities),
      );
      return Right(streamModel);
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (exception, stacktrace) {
      return Left(UnknownError(
        exception: exception,
        stackTrace: stacktrace,
        label: 'GetListRepository-getNotes',
      ));
    }
  }
}
