import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/error/failure.dart';
import 'package:safe_notes/app/shared/domain/entities/usuario_entity.dart';

abstract class ISetUserFirestoreUsecase {
  Future<Either<Failure, dynamic>> call(UsuarioEntity entity);
}

abstract class ICreateUserAuthenticationUsecase {
  Future<Either<Failure, String>> call(String email, String pass);
}
