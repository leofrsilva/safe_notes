import 'package:flutter_test/flutter_test.dart';
import 'package:safe_notes/app/shared/token/expire_token.dart';

void main() {
  final jwt = ExpireToken();

  test('Expire Generater Token | return Null', () async {
    await jwt.removeToken();
    final result = await jwt.checkToken();
    expect(result, isNull);
  });

  test('Expire Generater Token | return Map', () async {
    await jwt.generaterToken({
      'name': 'leonardo',
      'email': 'leonardo@gmail.com',
    });
    final result = await jwt.checkToken();
    expect(result, isNotNull);
    expect(result, isA<Map<String, dynamic>>());
    expect(result!['name'], equals('leonardo'));
    expect(result['email'], equals('leonardo@gmail.com'));
  });
}
