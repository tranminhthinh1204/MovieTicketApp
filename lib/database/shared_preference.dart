import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getUserIdFromSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('userId');
}
