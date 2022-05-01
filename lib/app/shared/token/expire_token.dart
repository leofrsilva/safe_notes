import 'dart:convert';
import 'package:encrypt/encrypt.dart' as crypt;

import 'package:safe_notes/app/design/common/extension/encrypt_extension.dart';
import 'i_expire_token.dart';
import 'token_shared.dart';

class ExpireToken extends IExpireToken {
  final _key = 'iYDMmVwjG5L6r54i20F9ew7z7YaghS92oZSySJCwXhY=';
  late TokenShared _tokenShared;

  static final ExpireToken _instance = ExpireToken._internal();

  factory ExpireToken() => _instance;

  ExpireToken._internal() {
    _tokenShared = TokenShared();
  }

  @override
  Future removeToken() async {
    await _tokenShared.removeToken();
  }

  @override
  Future<void> expireToken() async {
    final infoUser = await checkToken();

    if (infoUser != null) {
      infoUser.updateAll((key, value) {
        if (value is DateTime) {
          return 'Type-DateTime|||${value.millisecondsSinceEpoch}';
        }
        return value;
      });

      int issuedAt = DateTime.now().millisecondsSinceEpoch;
      int expire = DateTime.now().millisecondsSinceEpoch;

      final payload = {
        'iat': issuedAt,
        'exp': expire,
        'user': infoUser,
      };

      final strPayload = jsonEncode(payload);

      final key = crypt.Key.fromUtf8(_key.to32Length);
      final iv = crypt.IV.fromUtf8(_key.toIVString);
      final encrypter =
          crypt.Encrypter(crypt.AES(key, mode: crypt.AESMode.ctr));

      final encrypted = encrypter.encrypt(strPayload, iv: iv);
      final cipherPayload = encrypted.base64;
      final token = _base64UrlEncode(cipherPayload);

      await _tokenShared.setToken(token);
    }
  }

  @override
  Future<void> generaterToken(Map<String, dynamic> infoUser) async {
    infoUser.updateAll((key, value) {
      if (value is DateTime) {
        return 'Type-DateTime|||${value.millisecondsSinceEpoch}';
      }
      return value;
    });

    int issuedAt = DateTime.now().millisecondsSinceEpoch;
    int expire = DateTime.fromMillisecondsSinceEpoch(issuedAt)
        .add(const Duration(minutes: 15))
        .millisecondsSinceEpoch;

    final payload = {
      'iat': issuedAt,
      'exp': expire,
      'user': infoUser,
    };

    final strPayload = jsonEncode(payload);

    final key = crypt.Key.fromUtf8(_key.to32Length);
    final iv = crypt.IV.fromUtf8(_key.toIVString);
    final encrypter = crypt.Encrypter(crypt.AES(key, mode: crypt.AESMode.ctr));

    final encrypted = encrypter.encrypt(strPayload, iv: iv);
    final cipherPayload = encrypted.base64;
    final token = _base64UrlEncode(cipherPayload);

    await _tokenShared.setToken(token);
  }

  @override
  Future<Map<String, dynamic>?> checkToken() async {
    String? token = await _tokenShared.getToken();

    if (token != null) {
      final key = crypt.Key.fromUtf8(_key.to32Length);
      final iv = crypt.IV.fromUtf8(_key.toIVString);
      final decrypter =
          crypt.Encrypter(crypt.AES(key, mode: crypt.AESMode.ctr));

      token = _base64UrlDecode(token);
      final decrypted = decrypter.decryptBytes(
        crypt.Encrypted.fromBase64(token),
        iv: iv,
      );

      final strPayload = utf8.decode(decrypted);
      final payload = jsonDecode(strPayload);

      int expire = payload['exp'];
      int now = DateTime.now().millisecondsSinceEpoch;

      if (now <= expire) {
        Map<String, dynamic> user = payload['user'];
        user.updateAll((key, value) {
          if (value is String && value.contains('Type-DateTime|||')) {
            final milliseconds = int.tryParse(value.split('|||').last);
            return DateTime.fromMillisecondsSinceEpoch(milliseconds ?? 0);
          }
          return value;
        });
        return user;
      } else {
        Map<String, dynamic> user = payload['user'];
        return {
          'email': user['email'],
          'name': user['name'],
        };
      }
    }
    return null;
  }

  String _base64UrlEncode(String data) {
    final base64Url = HandleCode.strtr(data, {'+': '-', '/': '_'});
    return base64Url;
    // return HandleCode.rtrim(base64Url, charsToBeRemoved: '=');
  }

  String _base64UrlDecode(String base64Url) {
    return HandleCode.strtr(base64Url, {'-': '+', '_': '/'});
  }
}

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
