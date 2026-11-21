import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  static const _keyName = 'invoice_encryption_key';

  final FlutterSecureStorage _storage;

  EncryptionService({FlutterSecureStorage? storage}) : _storage = storage ?? const FlutterSecureStorage();

  Future<encrypt.Key> _getKey() async {
    String? keyString = await _storage.read(key: _keyName);

    if (keyString == null) {
      final key = encrypt.Key.fromUtf8('12345678901234567890123456789012');

      await _storage.write(
        key: _keyName,
        value: base64UrlEncode(key.bytes),
      );

      return key;
    }

    return encrypt.Key(
      base64Url.decode(keyString),
    );
  }

  Future<String> encryptData(Map<String, dynamic> data) async {
    final key = await _getKey();

    // Random IV for every encryption
    final iv = encrypt.IV.fromSecureRandom(16);

    final encrypter = encrypt.Encrypter(
      encrypt.AES(
        key,
        mode: encrypt.AESMode.cbc,
      ),
    );

    final jsonString = jsonEncode(data);

    final encrypted = encrypter.encrypt(
      jsonString,
      iv: iv,
    );

    // Store IV + encrypted data together
    return jsonEncode({
      'iv': base64UrlEncode(iv.bytes),
      'data': encrypted.base64,
    });
  }

  Future<Map<String, dynamic>> decryptData(String encryptedData) async {
    final key = await _getKey();

    final decoded = jsonDecode(encryptedData);

    final iv = encrypt.IV(
      base64Url.decode(decoded['iv']),
    );

    final encrypter = encrypt.Encrypter(
      encrypt.AES(
        key,
        mode: encrypt.AESMode.cbc,
      ),
    );

    final decrypted = encrypter.decrypt64(
      decoded['data'],
      iv: iv,
    );

    return jsonDecode(decrypted);
  }
}