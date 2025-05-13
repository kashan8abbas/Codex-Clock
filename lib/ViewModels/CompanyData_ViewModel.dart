import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CompanyDataViewModel with ChangeNotifier {
  String _code = '';

  String get code => _code;

  void updateCompanyData(
      String code) {
    _code = code;
    notifyListeners();
  }

  void clearData() {
    _code = '';
    notifyListeners();
  }
}
