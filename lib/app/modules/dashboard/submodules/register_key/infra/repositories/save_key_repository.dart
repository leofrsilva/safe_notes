import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/domain/models/usuario_model.dart';
import 'package:safe_notes/app/shared/errors/failure.dart';

import '../../domain/repositories/i_save_key_repository.dart';
import '../datasources/i_save_key_datasource.dart';

class SaveKeyRepository extends ISaveKeyRepository {
  final ISaveKeyDatasource _datasource;
  SaveKeyRepository(this._datasource);

  @override
  Future<Either<Failure, dynamic>> saveKey(
      UsuarioModel user, String keyText) async {
    try {
      final result = await _datasource.saveKey(user, keyText);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    } on Exception catch (exception, stacktrace) {
      return Left(UnknownError(
        exception: exception,
        stackTrace: stacktrace,
        label: 'SaveKeyRepository-saveKey',
      ));
    }
  }
}
