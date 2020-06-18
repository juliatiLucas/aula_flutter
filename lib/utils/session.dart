import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Session {
  Future<Map<String, dynamic>> getUserInfo() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userData') != null) {
      Map<String, dynamic> userData = await json.decode(prefs.getString('userData'));
      return userData;
    }
    return {'userData': '{}'};
  }

  Future<void> login(Map<String, dynamic> userData) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', json.encode(userData));
    prefs.setBool('isAuthenticated', true);
  }

  Future<void> logout() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', null);
    prefs.setBool('isAuthenticated', false);
    prefs.setString('token', null);
  }

  Future<bool> isAuthenticated() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isAuthenticated');
  }
}
