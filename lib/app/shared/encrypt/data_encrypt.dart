import 'dart:convert';

import 'package:safe_notes/app/design/common/extension/encrypt_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/widgets.dart';
import 'package:encrypt/encrypt.dart' as crypt;

import 'handle_code.dart';

class DataEncrypt {
  final keyNotifier = ValueNotifier<String>('');
  String get _keyInput => keyNotifier.value;

  Future setKey(
    String? value, {
    Future<String?> Function()? onSaveKey,
  }) async {
    keyNotifier.value = value?.trim() ?? '';
    if (value != null && value.isNotEmpty) {
      await _checkValue(onSaveKey);
    }
  }

  bool isCorrectKey = false;

  _checkValue(Future<String?> Function()? onSaveKey) async {
    var valueEncrypted = await _getCheckValue;
    if (valueEncrypted.isEmpty) {
      await onSaveKey?.call().then((key) async {
        if (key != null && keyNotifier.value == key) {
          isCorrectKey = true;
          await _setCheckValue();
        } else {
          isCorrectKey = false;
          await _deleteCheckValue();
        }
      });
    } else {
      if (decode(valueEncrypted) != _value) {
        isCorrectKey = false;
      } else {
        isCorrectKey = true;
      }
    }
  }

  final _value = 'Safe Notes';
  final _keyCheckValue = 'check-value';
  Future _deleteCheckValue() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(_keyCheckValue);
  }

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
    if (_keyInput.isNotEmpty && text.isNotEmpty) {
      final key = crypt.Key.fromUtf8(_keyInput.to32Length);
      final iv = crypt.IV.fromUtf8(_keyInput.toIVString);

      final encrypter = crypt.Encrypter(crypt.AES(
        key,
        mode: crypt.AESMode.ctr,
      ));

      final encrypted = encrypter.encrypt(text, iv: iv);
      final ciphertext = encrypted.base64;
      return _urlEncode(ciphertext);
    }
    return text;
  }

  String decode(String textCrypted) {
    if (_keyInput.isNotEmpty && textCrypted.isNotEmpty) {
      try {
        final key = crypt.Key.fromUtf8(_keyInput.to32Length);
        final iv = crypt.IV.fromUtf8(_keyInput.toIVString);

        // Decryption
        final decrypter = crypt.Encrypter(crypt.AES(
          key,
          mode: crypt.AESMode.ctr,
        ));
        final decrypted = decrypter.decryptBytes(
          crypt.Encrypted.fromBase64(_urlDecode(textCrypted)),
          iv: iv,
        );

        final decryptedData = utf8.decode(decrypted);
        return decryptedData;
      } catch (_) {
        return _decodeText(textCrypted);
      }
    }
    return _decodeText(textCrypted);
  }

  String _decodeText(String value) {
    return value.replaceAll('==', '');
  }

  String _urlEncode(String url) {
    final encodeUrl = HandleCode.strtr(url, {'+': '-', '/': '_'});
    return encodeUrl;
    // return HandleCode.rtrim(encodeUrl, charsToBeRemoved: '=');
  }

  String _urlDecode(String url) {
    return HandleCode.strtr(url, {'-': '+', '_': '/'});
  }
}
