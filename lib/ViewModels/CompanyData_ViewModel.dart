import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CompanyDataViewModel with ChangeNotifier {
  String _code = '';
  String _ip = '';
  bool _isCompany = false;

  String get code => _code;
  String get ip => _ip;
  bool get isCompany => _isCompany;

  void updateCompanyCode(
      String code) {
    _code = code;
    notifyListeners();
  }

  void updateCompanyIP(
      String ip) {
    _ip = ip;
    notifyListeners();
  }

  void updateIsCompany(bool value) {
    _isCompany = value;
    notifyListeners();
  }

  void clearData() {
    _code = '';
    _ip = '';
    _isCompany = false;
    notifyListeners();
  }
}
