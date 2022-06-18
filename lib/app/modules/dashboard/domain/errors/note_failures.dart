import 'package:safe_notes/app/shared/error/failure.dart';

class DeleteNotePersistentSqliteError extends Failure {
  DeleteNotePersistentSqliteError(
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

class DeleteNoteSqliteError extends Failure {
  DeleteNoteSqliteError(
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

class NoNoteEditedToDeletedSqliteError extends Failure {}

class RestoreNoteSqliteError extends Failure {
  RestoreNoteSqliteError(
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

class NoNoteEditedToRestoredSqliteError extends Failure {}

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
