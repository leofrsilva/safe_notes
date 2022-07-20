import 'package:fpdart/fpdart.dart';

import 'package:safe_notes/app/shared/error/failure.dart';
import 'package:safe_notes/app/shared/domain/entities/usuario_entity.dart';

import '../repositories/i_signup_firebase_repository.dart';
import 'i_signup_firebase_usecase.dart';

class SetUserFirestoreUsecase extends ISetUserFirestoreUsecase {
  final ISignupFirebaseRepository _firebaseRepository;
  SetUserFirestoreUsecase(this._firebaseRepository);

  @override
  Future<Either<Failure, dynamic>> call(UsuarioEntity entity) async {
    return await _firebaseRepository.insertUserFirestore(entity);
  }
}
