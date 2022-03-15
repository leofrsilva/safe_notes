extension StringExtension on String {
  int get asInt => codeUnitAt(0);
}

extension BoolExtension on bool {
  int get asInt {
    if (this) {
      return 1;
    }
    return 0;
  }
}

extension IntExtension on int {
  bool? get asBool {
    if (this == 0) {
      return false;
    } else if (this == 1) {
      return true;
    }
    return null;
  }

  String get asChar => String.fromCharCode(this);
}
