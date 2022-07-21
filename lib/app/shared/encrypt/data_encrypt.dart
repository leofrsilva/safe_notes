import 'dart:convert';

import 'package:encrypt/encrypt.dart' as crypt;
import 'package:safe_notes/app/design/common/extension/encrypt_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataEncrypt {
  String? _keyInput;
  setKey(String? value) {
    _keyInput = value?.trim();
    if (value != null && value.isNotEmpty) {
      _checkValue();
    }
  }

  bool isCorrectKey = false;

  _checkValue() async {
    var valueEncrypted = await _getCheckValue;
    if (valueEncrypted.isEmpty) {
      await _setCheckValue();
      isCorrectKey = true;
    } else {
      if (decode(valueEncrypted) != _value) {
        isCorrectKey = false;
      } else {
        isCorrectKey = true;
      }
    }

    print(isCorrectKey);
  }

  final _value = 'Safe Notes';
  final _keyCheckValue = 'check-value';
  Future _setCheckValue() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_keyCheckValue, encode(_value));
  }

  Future<String> get _getCheckValue async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String? encrypted = sharedPreferences.getString(_keyCheckValue);
    return encrypted ?? '';
  }

  String encode(String text) {
    if (_keyInput != null && text.isNotEmpty) {
      final key = crypt.Key.fromUtf8(_keyInput!.to32Length);
      final iv = crypt.IV.fromUtf8(_keyInput!.toIVString);

      final encrypter = crypt.Encrypter(crypt.AES(
        key,
        mode: crypt.AESMode.ctr,
      ));

      final encrypted = encrypter.encrypt(text, iv: iv);
      final ciphertext = encrypted.base64;
      return ciphertext;
    }
    return text;
  }

  String decode(String textCrypted) {
    if (_keyInput != null && textCrypted.isNotEmpty) {
      try {
        final key = crypt.Key.fromUtf8(_keyInput!.to32Length);
        final iv = crypt.IV.fromUtf8(_keyInput!.toIVString);

        // Decryption
        final decrypter = crypt.Encrypter(crypt.AES(
          key,
          mode: crypt.AESMode.ctr,
        ));
        final decrypted = decrypter.decryptBytes(
          crypt.Encrypted.fromBase64(textCrypted),
          iv: iv,
        );

        final decryptedData = utf8.decode(decrypted);
        return decryptedData;
      } catch (_) {
        return textCrypted;
      }
    }
    return textCrypted;
  }
}
