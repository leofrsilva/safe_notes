import 'package:safe_notes/app/shared/error/failure.dart';

class NoFoundUserInCreateUserAuthFirebase extends Failure {}

class CreateUserAuthFirebaseError extends Failure {
  CreateUserAuthFirebaseError(
    StackTrace stackTrace,
    String label,
    dynamic firebaseAuthException,
    String errorMessage,
  ) : super(
          stackTrace: stackTrace,
          label: label,
          exception: firebaseAuthException,
          errorMessage: errorMessage,
        );
}

// class SignupNoDataFoundFirestoreError extends Failure {}

class SignupFirestoreError extends Failure {
  SignupFirestoreError(
    String label,
    dynamic exception,
    String errorMessage,
  ) : super(
          label: label,
          exception: exception,
          errorMessage: errorMessage,
        );
}
