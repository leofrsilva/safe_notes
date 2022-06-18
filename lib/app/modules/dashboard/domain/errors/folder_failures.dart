import 'package:safe_notes/app/shared/error/failure.dart';

class AddFolderSqliteError extends Failure {
  AddFolderSqliteError(
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

class NotReturnFolderIdSqliteError extends Failure {}

class EditFolderSqliteError extends Failure {
  EditFolderSqliteError(
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

class NoFolderRecordsChangedSqliteError extends Failure {}

class DeleteFolderSqliteError extends Failure {
  DeleteFolderSqliteError(
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

class NoFolderEditedToDeletedSqliteError extends Failure {}

class RestoreFolderSqliteError extends Failure {
  RestoreFolderSqliteError(
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

class NoFolderEditedToRestoredSqliteError extends Failure {}

class DeleteFolderPersistentSqliteError extends Failure {
  DeleteFolderPersistentSqliteError(
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
