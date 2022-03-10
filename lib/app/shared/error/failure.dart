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
  final dynamic exception;
  final StackTrace? stackTrace;
  final String? label;

  UnknownError({
    String? errorMessage,
    this.label,
    this.exception,
    this.stackTrace,
  }) : super(
          stackTrace: stackTrace,
          label: label,
          exception: exception,
          errorMessage: errorMessage ?? 'Unknown Error',
        );
}
