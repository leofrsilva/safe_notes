import 'dart:convert';

import 'package:encrypt/encrypt.dart' as crypt;
import 'package:safe_notes/app/design/common/extension/encrypt_extension.dart';

class DataEncrypt {
  String? _keyInput;
  setKey(String? value) {
    _keyInput = value;
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
    }
    return textCrypted;
  }
}
