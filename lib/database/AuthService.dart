import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userIdKey = 'userId';
  static const String _userNameKey = 'userName';
  static const String _userEmailKey = 'userEmail';
  static const String _userRoleKey = 'userRole';

  Future<void> saveUserSession(String userId, String name, String email, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_userNameKey, name);
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_userRoleKey, role);
  }

  Future<void> clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userRoleKey);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<Map<String, String>?> getUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_isLoggedInKey) ?? false) {
      return {
        'userId': prefs.getString(_userIdKey) ?? '',
        'name': prefs.getString(_userNameKey) ?? '',
        'email': prefs.getString(_userEmailKey) ?? '',
        'role': prefs.getString(_userRoleKey) ?? '',
      };
    }
    return null;
  }
}
