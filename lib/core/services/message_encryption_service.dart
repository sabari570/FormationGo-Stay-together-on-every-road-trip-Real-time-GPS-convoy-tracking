import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

/// Encrypts/decrypts tour group chat messages before they are stored in Firestore.
///
/// Keys are derived from [journeyId] + [passCode]. This protects message bodies
/// from casual Firestore console viewing, but is not full E2E encryption because
/// the passcode is also stored on the journey document.
class MessageEncryptionService {
  final Map<String, Key> _keyCache = {};

  EncryptedPayload encrypt({
    required String journeyId,
    required String passCode,
    required String plaintext,
  }) {
    final key = _deriveKey(journeyId, passCode);
    final iv = IV.fromSecureRandom(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.gcm));
    final encrypted = encrypter.encrypt(plaintext, iv: iv);

    return EncryptedPayload(
      ciphertext: encrypted.base64,
      iv: iv.base64,
    );
  }

  String decrypt({
    required String journeyId,
    required String passCode,
    required String ciphertext,
    required String iv,
  }) {
    final key = _deriveKey(journeyId, passCode);
    final encrypter = Encrypter(AES(key, mode: AESMode.gcm));
    return encrypter.decrypt(
      Encrypted.fromBase64(ciphertext),
      iv: IV.fromBase64(iv),
    );
  }

  Key _deriveKey(String journeyId, String passCode) {
    final cacheKey = '$journeyId:$passCode';
    final cached = _keyCache[cacheKey];
    if (cached != null) return cached;

    final material = utf8.encode('formation_go:$journeyId:$passCode');
    final digest = sha256.convert(material);
    final key = Key(Uint8List.fromList(digest.bytes));
    _keyCache[cacheKey] = key;
    return key;
  }
}

class EncryptedPayload {
  final String ciphertext;
  final String iv;

  const EncryptedPayload({
    required this.ciphertext,
    required this.iv,
  });
}
