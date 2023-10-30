import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_keychain/flutter_keychain.dart';

const String COOKIE_PREFFIX = "cookie_jar";

class SecureStorage implements Storage {
  @override
  Future<void> delete(String key) {
    return FlutterKeychain.remove(key: key);
  }

  @override
  Future<void> deleteAll(List<String> keys) async {
    for (var key in keys) {
      await FlutterKeychain.remove(key: COOKIE_PREFFIX + key);
    }
  }

  @override
  Future<void> init(bool persistSession, bool ignoreExpires) async {}

  @override
  Future<String?> read(String key) {
    return FlutterKeychain.get(key: COOKIE_PREFFIX + key);
  }

  @override
  Future<void> write(String key, String value) {
    return FlutterKeychain.put(key: COOKIE_PREFFIX + key, value: value);
  }
}
