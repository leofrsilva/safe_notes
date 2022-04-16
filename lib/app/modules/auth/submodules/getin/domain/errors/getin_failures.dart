import 'package:safe_notes/app/shared/error/failure.dart';

class NoFoundUserInLoginAuthFirebase extends Failure {}

class LoginAuthFirebaseError extends Failure {
  LoginAuthFirebaseError(
    StackTrace stackTrace,
    String label,
    dynamic exception,
    String errorMessage,
  ) : super(
          stackTrace: stackTrace,
          label: label,
          exception: exception,
          errorMessage: errorMessage,
        );
}

class GetinNoDataFoundFirestoreError extends Failure {}

class GetinFirestoreError extends Failure {
  GetinFirestoreError(
    String label,
    dynamic exception,
    String errorMessage,
  ) : super(
          label: label,
          exception: exception,
          errorMessage: errorMessage,
        );
}
