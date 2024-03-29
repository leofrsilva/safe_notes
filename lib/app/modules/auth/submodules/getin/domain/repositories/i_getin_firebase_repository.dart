import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/errors/failure.dart';
import 'package:safe_notes/app/shared/domain/entities/usuario_entity.dart';

abstract class IGetinFirebaseRepository {
  Future<Either<Failure, String>> signIn(String email, String pass);
  Future<Either<Failure, UsuarioEntity>> getUserFirestore(String docRef);
  Future<Either<Failure, dynamic>> updateLoggedUserFirestore(String docRef);
}
