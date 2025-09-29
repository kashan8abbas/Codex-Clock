import 'package:flutter/material.dart';

class HomeViewmodel extends ChangeNotifier {
  Map<int, List<double>> _fetchDataDaily = {};
  Map<int, List<double>> _fetchDataWeek = {};
  Map<int, List<double>> _fetchDataYear = {};
  bool _isFirstLoad = true;
  int _sickLeaves = 0;
  int _casualLeaves = 0;
  int _absents = 0;

  Map<int, List<double>> get fetchDataDaily => _fetchDataDaily;
  Map<int, List<double>> get fetchDataWeek => _fetchDataWeek;
  Map<int, List<double>> get fetchDataYear => _fetchDataYear;
  bool get isFirstLoad => _isFirstLoad;
  int get sickLeaves => _sickLeaves;
  int get casualLeaves => _casualLeaves;
  int get absents => _absents;

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

  void setFirstLoad(bool val) {
    _isFirstLoad = val;
    notifyListeners();
  }

  void setLeaves(int sick, int casual, int absent) {
    _sickLeaves = sick;
    _casualLeaves = casual;
    _absents = absent;
    notifyListeners();
  }
}
