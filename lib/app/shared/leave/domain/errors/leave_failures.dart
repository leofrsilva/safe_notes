import 'package:safe_notes/app/shared/error/failure.dart';

class LeaveFirestoreError extends Failure {
  LeaveFirestoreError(
    String label,
    dynamic exception,
    String errorMessage,
  ) : super(
          label: label,
          exception: exception,
          errorMessage: errorMessage,
        );
}

class NoUserLoggedInAuthError extends Failure {}
