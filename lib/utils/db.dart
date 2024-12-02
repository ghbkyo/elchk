import 'package:get_storage/get_storage.dart';

///本地持久化存储工具类
class DB {
  DB._();
  static final GetStorage _box = GetStorage();
  static set(String name, dynamic value) => _box.write(name, value);
  static dynamic get(String name) => _box.read(name);
  static String getString(String name) => _box.read<String>(name) ?? '';
  static int getInt(String name) => _box.read<int>(name) ?? 0;
  static bool getBool(String name) => _box.read<bool>(name) ?? false;
  static remove(String name) => _box.remove(name);
}

class Cache {
  Cache._();

  // 设置缓存
  static dynamic set(String name, dynamic value, Duration du) {
    DB.set('${name}_cache', 1);
    DB.set('${name}_datetime', DateTime.now().millisecondsSinceEpoch);
    DB.set('${name}_duration', du.inMilliseconds);
    DB.set('${name}_value', value);
  }

  // 添加缓存
  static dynamic get(String name) {
    int cache = DB.getInt('${name}_cache');
    if (cache == 0) return null;
    DateTime dt =
        DateTime.fromMillisecondsSinceEpoch(DB.get('${name}_datetime'));
    int du = DB.get('${name}_duration');
    DateTime now = DateTime.now();
    if (now.difference(dt).inMilliseconds > du) {
      return null;
    }

    return DB.get('${name}_value');
  }
}
