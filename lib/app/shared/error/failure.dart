import 'package:flutter/cupertino.dart';

abstract class Failure {
  final String errorMessage;

  Failure({
    StackTrace? stackTrace,
    String? label,
    dynamic exception,
    this.errorMessage = '',
  }) {
    if (stackTrace != null) {
      debugPrintStack(label: label, stackTrace: stackTrace);
    }
    // Error Report
  }
}

class UnknownError extends Failure {
  UnknownError({
    String? errorMessage,
    dynamic exception,
    StackTrace? stackTrace,
    String? label,
  }) : super(
          stackTrace: stackTrace,
          label: label,
          exception: exception,
          errorMessage: errorMessage ?? 'Unknown Error',
        );
}

abstract class NoInternetConnection extends Failure {
  NoInternetConnection() : super(errorMessage: 'Sem conexão com a Internet');
}

class NoDataFound extends Failure {}
