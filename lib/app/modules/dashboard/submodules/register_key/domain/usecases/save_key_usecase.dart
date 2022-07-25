import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/domain/models/usuario_model.dart';
import 'package:safe_notes/app/shared/errors/failure.dart';

import '../repositories/i_save_key_repository.dart';

abstract class ISaveKeyUsecase {
  Future<Either<Failure, dynamic>> call(UsuarioModel user, String keyText);
}

class SaveKeyUsecase extends ISaveKeyUsecase {
  final ISaveKeyRepository _repository;
  SaveKeyUsecase(this._repository);

  @override
  Future<Either<Failure, dynamic>> call(
      UsuarioModel user, String keyText) async {
    return await _repository.saveKey(user, keyText);
  }
}
