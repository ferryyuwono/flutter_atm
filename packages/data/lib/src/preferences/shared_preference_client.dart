import 'package:data/data.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton()
class SharedPreferenceClient {
  final SharedPreferences _prefs;

  SharedPreferenceClient(this._prefs);

  Future<T> getObject<T>({
    required String key,
    required ObjectMapper<T> mapper,
  }) async {
    final json = _prefs.getString(key);
    return mapper.mapToObject(json);
  }

  Future<bool> setObject<T>({
    required String key,
    required T object,
    required ObjectMapper<T> mapper,
  }) async {
    final json = mapper.mapToJson(object).toString();
    return _prefs.setString(key, json);
  }
}
