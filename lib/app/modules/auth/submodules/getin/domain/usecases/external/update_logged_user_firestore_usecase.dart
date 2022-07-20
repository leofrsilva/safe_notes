import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

import '../../repositories/i_getin_firebase_repository.dart';
import 'i_getin_firebase_usecase.dart';

class UpdateLoggedUserFirestoreUsecase
    extends IUpdateLoggedUserFirestoreUsecase {
  final IGetinFirebaseRepository _firebaseRepository;
  UpdateLoggedUserFirestoreUsecase(this._firebaseRepository);

  @override
  Future<Either<Failure, dynamic>> call(String docRef) async {
    return await _firebaseRepository.updateLoggedUserFirestore(docRef);
  }
}
