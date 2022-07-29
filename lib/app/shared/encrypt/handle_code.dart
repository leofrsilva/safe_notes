class HandleCode {
  static String strtr(String b64, Map<String, String> fromTo) {
    fromTo.forEach((from, to) {
      b64 = b64.replaceAll(from, to);
    });
    return b64;
  }

  static String rtrim(String str, {String? charsToBeRemoved}) {
    if (charsToBeRemoved == null) {
      return str.trimRight();
    } else {
      List<String> charList = charsToBeRemoved.split('');

      String lastChar = str.split('').last;
      while (charList.contains(lastChar)) {
        int lastHash = str.length - 1;
        str = str.substring(0, lastHash);
        lastChar = str.split('').last;
      }
      return str;
    }
  }
}
