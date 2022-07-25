import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/errors/failure.dart';
import 'package:safe_notes/app/shared/domain/models/usuario_model.dart';

abstract class ISaveKeyRepository {
  Future<Either<Failure, dynamic>> saveKey(UsuarioModel user, String keyText);
}
