import 'dart:convert';

import 'package:encrypt/encrypt.dart' as crypt;

class InfoEncrypt {
  static String? _keyInput;

  static Future<String> encrypt(String text) async {
    String textCrypted = text;
    if (_keyInput != null) {
      final key = crypt.Key.fromUtf8(/*_keyInput.to32Lenght()*/ '');
      final iv = crypt.IV.fromUtf8(/*_keyInput.toIVString()*/ '');

      final encrypter = crypt.Encrypter(crypt.AES(
        key,
        mode: crypt.AESMode.ctr,
      ));

      final encrypted = encrypter.encrypt(text, iv: iv);
      final ciphertext = encrypted.base64;
      print(ciphertext);
    }
    return textCrypted;
  }

  static Future<String> decrypt(String textCrypted) async {
    String text = textCrypted;
    if (_keyInput != null) {
      final key = crypt.Key.fromUtf8(/*_keyInput!.to32Lenght()*/ '');
      final iv = crypt.IV.fromUtf8(/*_keyInput.toIVString()*/ '');

      // Decryption
      final decrypter = crypt.Encrypter(
        crypt.AES(key, mode: crypt.AESMode.ctr),
      );
      final decrypted = decrypter.decryptBytes(
        crypt.Encrypted.fromBase64(textCrypted),
        iv: iv,
      );
      final decryptedData = utf8.decode(decrypted);
      print(decryptedData);

      text = decryptedData;
    }
    return text;
  }
}
