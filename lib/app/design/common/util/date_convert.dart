class DateConvert {
  static String dateToString(DateTime date) {
    var now = DateTime.now();
    if (now.year == date.year) {
      return '${date.day} de ${abrv(date.month)}';
    } else {
      return '${date.day} de ${abrv(date.month)} de ${date.year}';
    }
  }

  static String abrv(int numMonth) {
    var month = '';
    switch (numMonth) {
      case 1:
        month = 'jan';
        break;
      case 2:
        month = 'fev';
        break;
      case 3:
        month = 'mar';
        break;
      case 4:
        month = 'abr';
        break;
      case 5:
        month = 'mai';
        break;
      case 6:
        month = 'jun';
        break;
      case 7:
        month = 'jul';
        break;
      case 8:
        month = 'ago';
        break;
      case 9:
        month = 'set';
        break;
      case 10:
        month = 'out';
        break;
      case 11:
        month = 'nov';
        break;
      case 12:
        month = 'dez';
        break;
    }
    return month;
  }
}
