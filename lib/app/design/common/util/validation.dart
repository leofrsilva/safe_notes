import 'package:intl/intl.dart';
import 'package:safe_notes/app/design/common/util/date_constant.dart';

class Validation {
  static bool ofEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  static bool ofData(String data) {
    if (data.length < 10) return false;
    final componentsDate =
        data.split('/').map((number) => int.tryParse(number)).toList();

    DateTime datetime = DateFormat("d/M/y").parse(data);
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
}
