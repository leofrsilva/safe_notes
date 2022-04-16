import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/shared/error/failure.dart';
import '../repositories/i_signup_firebase_repository.dart';
import 'i_signup_firebase_usecase.dart';

class CreateUserAuthenticationUsecase extends ICreateUserAuthenticationUsecase {
  final ISignupFirebaseRepository _firebaseRepository;
  CreateUserAuthenticationUsecase(this._firebaseRepository);

  @override
  Future<Either<Failure, String>> call(String email, String pass) {
    return _firebaseRepository.signUp(email, pass);
  }
}
