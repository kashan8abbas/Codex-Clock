import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CompanyDataViewModel with ChangeNotifier {
  String _code = '';
  String _ip = '';
  bool _isCompany = false;
  int _workingTime = 0;
  Map<String, dynamic> _timingFrom = {};
  Map<String, dynamic> _timingTo = {};
  Map<String, dynamic> _weeklyHours = {};
  Map<String, dynamic> _monthlyHours = {};
  Map<String, dynamic> _yearlyHours = {};

  String get code => _code;
  String get ip => _ip;
  bool get isCompany => _isCompany;
  int get workingTime => _workingTime;
  Map<String, dynamic> get timingFrom => _timingFrom;
  Map<String, dynamic> get timingTo => _timingTo;
  Map<String, dynamic> get weeklyHours => _weeklyHours;
  Map<String, dynamic> get monthlyHours => _monthlyHours;
  Map<String, dynamic> get yearlyHours => _yearlyHours;

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

  void setTimings(Map<String, dynamic> from, Map<String, dynamic> to, Map<String, dynamic> weekly, Map<String, dynamic> monthly, Map<String, dynamic> yearly, int workingTime){
    _timingFrom = from;
    _timingTo = to;
    _weeklyHours = weekly;
    _monthlyHours = monthly;
    _yearlyHours = yearly;
    _workingTime = workingTime;
    notifyListeners();
  }

  void clearData() {
    _code = '';
    _ip = '';
    _isCompany = false;
    notifyListeners();
  }
}
