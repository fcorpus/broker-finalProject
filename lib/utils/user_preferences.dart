import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static SharedPreferences? _prefs;

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setUserId(int id) async {
    await _prefs?.setInt('user_id', id);
  }

  static int? getUserId() => _prefs?.getInt('user_id');

  static Future<void> clearUser() async {
    await _prefs?.remove('user_id');
  }
}