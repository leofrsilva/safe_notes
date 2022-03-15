extension StringExtension on String {
  int get toInt => codeUnitAt(0);

  DateTime get toDateTime => DateTime.parse(this);
}

extension BoolExtension on bool {
  int get toInt {
    if (this) {
      return 1;
    }
    return 0;
  }
}

extension IntExtension on int {
  bool? get toBool {
    if (this == 0) {
      return false;
    } else if (this == 1) {
      return true;
    }
    return null;
  }

  String get toChar => String.fromCharCode(this);
}
