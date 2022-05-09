import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

import '../../domain/repositories/i_lixeira_repository.dart';
import '../datasources/i_lixeira_datasource.dart';

class LixeiraRepository extends ILixeiraRepository {
  final ILixeiraDatasource _datasource;
  LixeiraRepository(this._datasource);

  @override
  Future<Either<Failure, List<NoteModel>>> getNotesDeleted() async {
    try {
      final listEntity = await _datasource.getNotesDeleted();
      final listModel =
          listEntity.map((entity) => NoteModel.fromEntity(entity)).toList();
      return Right(listModel);
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (exception, stacktrace) {
      return Left(UnknownError(
        exception: exception,
        stackTrace: stacktrace,
        label: 'LixeiraRepository-getNotesDeleted',
      ));
    }
  }
}
