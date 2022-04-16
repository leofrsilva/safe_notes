import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/error/failure.dart';
import 'package:safe_notes/app/shared/domain/entities/usuario_entity.dart';

import '../../domain/repositories/i_getin_firebase_repository.dart';
import '../datasources/i_getin_firebase_datasource.dart';

class GetinFirebaseRepository extends IGetinFirebaseRepository {
  final IGetinFirebaseDatasource _datasource;
  GetinFirebaseRepository(this._datasource);

  @override
  Future<Either<Failure, UsuarioEntity>> getUserFirestore(String docRef) async {
    try {
      final model = await _datasource.getUserFirestore(docRef);
      return Right(model);
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (exception, stacktrace) {
      return Left(UnknownError(
        exception: exception,
        stackTrace: stacktrace,
        label: 'GetinFirebaseRepository-getUserFirestore',
      ));
    }
  }

  @override
  Future<Either<Failure, String>> signIn(String email, String pass) async {
    try {
      final uid = await _datasource.signIn(email, pass);
      return Right(uid);
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (exception, stacktrace) {
      return Left(UnknownError(
        exception: exception,
        stackTrace: stacktrace,
        label: 'GetinFirebaseRepository-signIn',
      ));
    }
  }
}
