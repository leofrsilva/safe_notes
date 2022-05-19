import 'package:intl/intl.dart';
import 'package:safe_notes/app/design/common/util/date_constant.dart';

import '../util/date_convert.dart';

extension StringExtension on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  int get toInt => codeUnitAt(0);

  DateTime get toDateTime => DateTime.parse(this);

  bool get isValidDate {
    if (length < 10) return false;
    final componentsDate =
        split('/').map((number) => int.tryParse(number)).toList();
    DateTime datetime = DateFormat("d/M/y").parse(this);
    int year = componentsDate[2] ?? 0;
    int month = componentsDate[1] ?? 0;
    int day = componentsDate[0] ?? 0;

    final now = DateTime.now();
    final minYear = now.year - DateConstant.rangeOfYears;

    return year == datetime.year &&
        year <= now.year &&
        year > minYear &&
        month == datetime.month &&
        day == datetime.day;
  }

  DateTime? get toConvertDateTime {
    if (isValidDate) {
      return DateFormat("d/M/y").parse(this);
    }
    return null;
  }
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

extension DateTimeExtension on DateTime {
  String get toOriginalFormatString {
    final y = year.toString().padLeft(4, '0');
    final m = month.toString().padLeft(2, '0');
    final d = day.toString().padLeft(2, '0');
    return "$d/$m/$y";
  }

  String get toStrDate {
    final y = year.toString().padLeft(4, '0');
    final m = month.toString().padLeft(2, '0');
    final strM = DateConvert.abrv(int.parse(m));
    final d = day.toString().padLeft(2, '0');

    return "$d de $strM de $y";
  }

  String get toStrDateTime {
    final y = year.toString().padLeft(4, '0');
    final m = month.toString().padLeft(2, '0');
    final strM = DateConvert.abrv(int.parse(m));
    final d = day.toString().padLeft(2, '0');

    final h = hour;
    final min = minute;

    return "$d de $strM de $y $h:$min";
  }
}
