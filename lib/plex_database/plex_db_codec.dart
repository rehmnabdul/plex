import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sembast/sembast.dart';

const String _plexDbKeyStorageKey = 'plex_db_key';

/// Creates an AES-256-CBC SembastCodec for database encryption.
///
/// [key] must be 32 bytes. Use [getOrCreateDbKey] to obtain a key from secure storage.
SembastCodec createAesEncryptionCodec(List<int> key) {
  if (key.length != 32) {
    throw ArgumentError('Encryption key must be 32 bytes, got ${key.length}');
  }
  final enc = Encrypter(AES(Key(Uint8List.fromList(key)), mode: AESMode.cbc));
  final codec = _AesSembastCodec(enc);

  return SembastCodec(
    signature: 'plex-aes-256-cbc',
    codec: codec,
  );
}

class _AesSembastCodec extends Codec<Object?, String> {
  _AesSembastCodec(this._enc);

  final Encrypter _enc;

  @override
  Converter<Object?, String> get encoder => _AesEncoder(_enc);

  @override
  Converter<String, Object?> get decoder => _AesDecoder(_enc);

  @override
  String encode(Object? input) => encoder.convert(input);

  @override
  Object? decode(String encoded) => decoder.convert(encoded);
}

class _AesEncoder extends Converter<Object?, String> {
  _AesEncoder(this._enc);

  final Encrypter _enc;

  @override
  String convert(Object? input) {
    final json = jsonEncode(input);
    final iv = IV.fromSecureRandom(16);
    final encrypted = _enc.encrypt(json, iv: iv);
    final combined = Uint8List.fromList([...iv.bytes, ...encrypted.bytes]);
    return base64Encode(combined);
  }
}

class _AesDecoder extends Converter<String, Object?> {
  _AesDecoder(this._enc);

  final Encrypter _enc;

  @override
  Object? convert(String encoded) {
    final combined = base64Decode(encoded);
    final iv = IV(Uint8List.fromList(combined.sublist(0, 16)));
    final encrypted = Encrypted(Uint8List.fromList(combined.sublist(16)));
    final json = _enc.decrypt(encrypted, iv: iv);
    return jsonDecode(json) as Object?;
  }
}

/// Loads or creates a 32-byte key for database encryption.
///
/// Uses [FlutterSecureStorage] to persist the key.
Future<List<int>> getOrCreateDbKey([FlutterSecureStorage? storage]) async {
  final store = storage ?? const FlutterSecureStorage();
  var stored = await store.read(key: _plexDbKeyStorageKey);
  if (stored != null) {
    try {
      final bytes = base64Decode(stored);
      if (bytes.length == 32) return bytes.toList();
    } catch (_) {}
  }
  final newKey = _generateAesKey();
  await store.write(key: _plexDbKeyStorageKey, value: base64Encode(newKey));
  return newKey;
}

List<int> _generateAesKey() => IV.fromSecureRandom(32).bytes.toList();
