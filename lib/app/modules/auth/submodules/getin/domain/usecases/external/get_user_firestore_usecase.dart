import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/error/failure.dart';
import 'package:safe_notes/app/shared/domain/entities/usuario_entity.dart';

import '../../repositories/i_getin_firebase_repository.dart';
import 'i_getin_firebase_usecase.dart';

class GetUserFirestoreUsecase extends IGetUserFirestoreUsecase {
  final IGetinFirebaseRepository _firebaseRepository;
  GetUserFirestoreUsecase(this._firebaseRepository);

  @override
  Future<Either<Failure, UsuarioEntity>> call(String docRef) async {
    return await _firebaseRepository.getUserFirestore(docRef);
  }
}
