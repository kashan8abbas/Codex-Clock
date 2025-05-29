import 'package:flutter/material.dart';

class HomeViewmodel extends ChangeNotifier {
  Map<int, List<double>> _fetchDataDaily = {};
  Map<int, List<double>> _fetchDataWeek = {};
  Map<int, List<double>> _fetchDataYear = {};

  Map<int, List<double>> get fetchDataDaily => _fetchDataDaily;
  Map<int, List<double>> get fetchDataWeek => _fetchDataWeek;
  Map<int, List<double>> get fetchDataYear => _fetchDataYear;

  void setFetchDataDaily(List<double> data) {
    _fetchDataDaily = {
      0: data
    };
    notifyListeners();
  }

  void setFetchDataWeek(List<double> data) {
    _fetchDataWeek = {
      1: data
    };
    notifyListeners();
  }

  void setFetchDataYear(List<double> data) {
    _fetchDataYear = {
      2: data
    };
    notifyListeners();
  }
}
