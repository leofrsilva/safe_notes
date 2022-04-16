import 'package:flutter_test/flutter_test.dart';
import 'package:safe_notes/app/design/common/extension/encrypt_extension.dart';

void main() {
  test('encrypt extension | Lenght igual 32', () {
    String text = 'my 32 length key................';
    final result = text.to32Length;
    expect(result.length, equals(32));
  });

  test('encrypt extension | Lenght menor que 32', () {
    String text = 'ADEVT134SADF1231F7&&GGG';
    final result = text.to32Length;
    expect(result.length, equals(32));
  });

  test('encrypt extension | Lenght maior que 32', () {
    String text = 'ADEVT134SADF1231F7&&RF11RR44BB55!!BB2277';
    final result = text.to32Length;
    expect(result.length, equals(32));
  });
}
