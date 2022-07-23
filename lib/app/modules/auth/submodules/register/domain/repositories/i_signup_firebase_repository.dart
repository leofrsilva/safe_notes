import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/errors/failure.dart';
import 'package:safe_notes/app/shared/domain/entities/usuario_entity.dart';

abstract class ISignupFirebaseRepository {
  Future<Either<Failure, dynamic>> insertUserFirestore(UsuarioEntity entity);
  Future<Either<Failure, String>> signUp(String email, String pass);
}
