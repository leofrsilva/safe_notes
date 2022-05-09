import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/error/failure.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';

import '../repositories/i_lixeira_repository.dart';
import 'i_lixeira_usecases.dart';

class GetNotesDeletedUsecase extends IGetNotesDeletedUsecase {
  final ILixeiraRepository _repository;
  GetNotesDeletedUsecase(this._repository);

  @override
  Future<Either<Failure, List<NoteModel>>> call() {
    return _repository.getNotesDeleted();
  }
}
