import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_keychain/flutter_keychain.dart';

const String COOKIE_PREFFIX = "cookie_jar";

class SecureStorage implements Storage {
  SecureStorage({String? cookiePreffix = '', String? fileFailoverDirectory}) {
    this.preffix = cookiePreffix;
    this.dir = fileFailoverDirectory;
  }

  String? preffix;
  String? dir;
  Storage? _failoverStorage;

  @override
  Future<void> delete(String key) {
    return FlutterKeychain.remove(key: preffix! + key);
  }

  @override
  Future<void> deleteAll(List<String> keys) async {
    for (var key in keys) {
      await FlutterKeychain.remove(key: preffix! + key);
    }
  }

  @override
  Future<void> init(bool persistSession, bool ignoreExpires) async {
    preffix = preffix != null ? preffix : COOKIE_PREFFIX;
    if (dir != null) {
      _failoverStorage = FileStorage(dir);
      await _failoverStorage!.init(true, false);
    }
  }

  @override
  Future<String?> read(String key) async {
    // If _failoverStorage is being used we try to read the key from it
    // and store it on the keychain for later usage.
    if (_failoverStorage != null) {
      var _foVal = await _failoverStorage!.read(key);
      if (_foVal != null) {
        await FlutterKeychain.put(key: preffix! + key, value: _foVal);
        await _failoverStorage!.delete(key);
        return _foVal;
      }
    }
    return FlutterKeychain.get(key: preffix! + key);
  }

  @override
  Future<void> write(String key, String value) {
    return FlutterKeychain.put(key: preffix! + key, value: value);
  }
}
