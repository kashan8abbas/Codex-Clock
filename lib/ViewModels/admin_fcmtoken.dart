import 'package:flutter/cupertino.dart';

class AdminFcmTokenViewModel with ChangeNotifier{
  String _adminToken = '';

  String get adminToken => _adminToken;

  void setAdminToken(String token) {
    _adminToken = token;
    notifyListeners();
  }
}