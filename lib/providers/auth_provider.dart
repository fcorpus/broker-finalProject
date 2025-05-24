import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _username;

  String get username => _username ?? '';

  bool get isLoggedIn => _username != null;

  AuthProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username');
    notifyListeners();
  }

  Future<void> login(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    _username = username;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    _username = null;
    notifyListeners();
  }

  Future<List<String>> getUserList() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('user_list') ?? [];
  }

  Future<void> addUser(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final users = prefs.getStringList('user_list') ?? [];
    if (!users.contains(username)) {
      users.add(username);
      await prefs.setStringList('user_list', users);
    }
    await login(username);
  }

  Future<void> deleteUser(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final users = prefs.getStringList('user_list') ?? [];
    users.remove(username);
    await prefs.setStringList('user_list', users);

    
    if (_username == username) {
      await logout();
    }

    notifyListeners();
  }

}
