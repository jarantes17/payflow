import 'package:flutter/material.dart';
import 'package:payflow/shared/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  var _isAuthenticated = false;
  UserModel? _user;

  UserModel get user => _user!;
  get isAuthenticated => _isAuthenticated;

  void setUser(BuildContext context, UserModel? user) {
    if (user != null) {
      _user = user;
      _isAuthenticated = true;
      saveUser(user);
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      _user = null;
      _isAuthenticated = false;
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  Future<void> saveUser(UserModel user) async {
    final instance = await SharedPreferences.getInstance();
    await instance.setString("user", user.toJson());
    return;
  }

  Future<void> currentUser(BuildContext context) async {
    final instance = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 2));
    if (instance.containsKey("user")) {
      final json = instance.getString("user");
      setUser(context, UserModel.fromJson(json!));
    } else {
      setUser(context, null);
    }

    return;
  }
}
