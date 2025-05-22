import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codex_clock/Services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkedEntry {
  final DateTime date;
  final Duration duration;

  WorkedEntry(this.date, this.duration);
}

class SummaryViewModel extends ChangeNotifier {

  final UserService _userService = UserService();

  SummaryViewModel() {
    _userService.loadAttendanceRecords(this);
  }

  int selectedTab = 0;
  DateTime focusedDay = DateTime.now();

  Map<String, bool> _attendanceRecords = {};
  List<WorkedEntry> _allWorkedDurations = [];

  Map<String, bool> get attendanceRecords => _attendanceRecords;
  List<WorkedEntry> get allWorkedDurations => _allWorkedDurations;

  void setAttendanceRecords(Map<String, bool> temp) {
    _attendanceRecords = temp;
    notifyListeners();
  }

  void setAllWorkedDurations(List<WorkedEntry> temp) {
    _allWorkedDurations = temp;
    notifyListeners();
  }

  void setSelectedTab(int index) {
    selectedTab = index;
    notifyListeners();
  }

  void setFocusedDay(DateTime day) {
    focusedDay = day;
    notifyListeners();
  }

  void previousMonth() {
    if (focusedDay.year == 2025 && focusedDay.month == 1) return;

    focusedDay = DateTime(focusedDay.year, focusedDay.month - 1, 1);
    notifyListeners();
  }

  void nextMonth() {
    focusedDay = DateTime(focusedDay.year, focusedDay.month + 1, 1);
    notifyListeners();
  }

  String get selectedMonth {
    return DateFormat.yMMMM().format(focusedDay);
  }

  void updateFocusedDay(DateTime newFocusedDay) {
    focusedDay = DateTime(newFocusedDay.year, newFocusedDay.month, newFocusedDay.day);
    notifyListeners();
  }

  /// ---------------- Duration Calculations ----------------
  List<double> getDailyWorkedHours(DateTime referenceDate) {
    final startOfWeek = referenceDate.subtract(Duration(days: referenceDate.weekday)); // Monday
    final endOfWeek = startOfWeek.add(const Duration(days: 7));
    List<double> tempList = [];
    print(allWorkedDurations.first.date);
    for (final entry in allWorkedDurations) {
      if (!entry.date.isBefore(startOfWeek) && entry.date.isBefore(endOfWeek)) {
        print(entry.duration.inHours.toDouble());
        tempList.add(entry.duration.inHours.toDouble());
      }
    }
    return tempList;
  }

  Duration getWeeklyWorkedHours(DateTime referenceDate) {
    final startOfWeek = referenceDate.subtract(Duration(days: referenceDate.weekday)); // Monday
    final endOfWeek = startOfWeek.add(const Duration(days: 7));
    return _sumDurationsBetween(startOfWeek, endOfWeek);
  }

  Duration getMonthlyWorkedHours(DateTime referenceDate) {
    final startOfMonth = DateTime(referenceDate.year, referenceDate.month);
    final endOfMonth = DateTime(referenceDate.year, referenceDate.month + 1);
    return _sumDurationsBetween(startOfMonth, endOfMonth);
  }

  Duration getYearlyWorkedHours(DateTime referenceDate) {
    final startOfYear = DateTime(referenceDate.year);
    final endOfYear = DateTime(referenceDate.year + 1);
    return _sumDurationsBetween(startOfYear, endOfYear);
  }

  Duration _sumDurationsBetween(DateTime start, DateTime end) {
    Duration total = Duration();
    for (final entry in allWorkedDurations) {
      if (!entry.date.isBefore(start) && entry.date.isBefore(end)) {
        total += entry.duration;
      }
    }
    return total;
  }


  String formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes % 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}";
  }
}
