import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/domain/models/usuario_model.dart';
import 'package:safe_notes/app/shared/error/failure.dart';
import 'package:safe_notes/app/shared/domain/entities/usuario_entity.dart';

import '../../domain/repositories/i_signup_firebase_repository.dart';
import '../datasources/i_signup_firebase_datasource.dart';

class SignupFirebaseRepository extends ISignupFirebaseRepository {
  final ISignupFirebaseDatasource _datasource;
  SignupFirebaseRepository(this._datasource);

  @override
  Future<Either<Failure, dynamic>> insertUserFirestore(
      UsuarioEntity entity) async {
    try {
      final result = await _datasource.insertUserFirestore(
        UsuarioModel.fromEntity(entity),
      );
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (exception, stacktrace) {
      return Left(UnknownError(
        exception: exception,
        stackTrace: stacktrace,
        label: 'SignupFirebaseRepository-insertUserFirestore',
      ));
    }
  }

  @override
  Future<Either<Failure, String>> signUp(String email, String pass) async {
    try {
      final uid = await _datasource.signUp(email, pass);
      return Right(uid);
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (exception, stacktrace) {
      return Left(UnknownError(
        exception: exception,
        stackTrace: stacktrace,
        label: 'SignupFirebaseRepository-signUp',
      ));
    }
  }
}
