import 'package:safe_notes/app/shared/error/failure.dart';

class DeleteNoteEmptySqliteError extends Failure {
  DeleteNoteEmptySqliteError(
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

class AddNoteSqliteError extends Failure {
  AddNoteSqliteError(
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

class NotReturnNoteIdSqliteError extends Failure {}

class EditNoteSqliteError extends Failure {
  EditNoteSqliteError(
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

class NoNoteRecordsChangedSqliteError extends Failure {}
