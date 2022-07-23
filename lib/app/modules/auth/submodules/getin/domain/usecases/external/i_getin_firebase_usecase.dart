import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/domain/entities/usuario_entity.dart';
import 'package:safe_notes/app/shared/errors/failure.dart';

abstract class ILoginAuthenticationUsecase {
  Future<Either<Failure, String>> call(String email, String pass);
}

abstract class IGetUserFirestoreUsecase {
  Future<Either<Failure, UsuarioEntity>> call(String docRef);
}

abstract class IUpdateLoggedUserFirestoreUsecase {
  Future<Either<Failure, dynamic>> call(String docRef);
}
