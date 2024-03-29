import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/errors/failure.dart';

import '../../repositories/i_getin_firebase_repository.dart';
import 'i_getin_firebase_usecase.dart';

class LoginAuthenticationUsecase extends ILoginAuthenticationUsecase {
  final IGetinFirebaseRepository _firebaseRepository;
  LoginAuthenticationUsecase(this._firebaseRepository);

  @override
  Future<Either<Failure, String>> call(String email, String pass) async {
    return await _firebaseRepository.signIn(email, pass);
  }
}
