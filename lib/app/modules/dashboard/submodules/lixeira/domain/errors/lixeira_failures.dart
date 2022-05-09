import 'package:safe_notes/app/shared/error/failure.dart';

class GetNotesDeletedSqliteError extends Failure {
  GetNotesDeletedSqliteError(
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
