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
    final startOfWeek = referenceDate.subtract(Duration(days: referenceDate.weekday - 1)); // Monday
    List<double> dailyHours = List.filled(5, 0.0); // Monday to Friday

    for (final entry in _allWorkedDurations) {
      final entryDate = entry.date;
      for (int i = 0; i < 5; i++) {
        final currentDay = startOfWeek.add(Duration(days: i));
        if (_isSameDate(entryDate, currentDay)) {
          dailyHours[i] = entry.duration.inHours.toDouble();
          break;
        }
      }
    }
    return dailyHours;
  }

  List<double> getWeeklyWorkedHoursTotalsForMonth(int year, int month) {
    List<double> weeklyTotals = [];

    DateTime firstDayOfMonth = DateTime(year, month, 1);
    DateTime lastDayOfMonth = DateTime(year, month + 1, 0);

    // Find the first Monday on or after the 1st
    DateTime currentMonday = firstDayOfMonth;
    while (currentMonday.weekday != DateTime.monday) {
      currentMonday = currentMonday.add(const Duration(days: 1));
    }

    while (currentMonday.isBefore(lastDayOfMonth) || _isSameDate(currentMonday, lastDayOfMonth)) {
      List<double> dailyHours = [];

      for (int i = 0; i < 5; i++) {
        DateTime currentDay = currentMonday.add(Duration(days: i));
        if (currentDay.month != month || currentDay.isAfter(lastDayOfMonth)) break;

        double hours = 0.0;
        for (final entry in _allWorkedDurations) {
          if (_isSameDate(entry.date, currentDay)) {
            hours = entry.duration.inMinutes / 60.0;
            break;
          }
        }

        dailyHours.add(double.parse(hours.toStringAsFixed(1)));
      }

      double total = dailyHours.fold(0.0, (sum, h) => sum + h);
      weeklyTotals.add(total);

      currentMonday = currentMonday.add(const Duration(days: 7));
    }

    return weeklyTotals;
  }

  List<double> getMonthlyWorkedHoursTotalsForYear(int year) {
    List<double> monthlyTotals = [];

    for (int month = 1; month <= 12; month++) {
      DateTime firstDayOfMonth = DateTime(year, month, 1);
      DateTime lastDayOfMonth = DateTime(year, month + 1, 0);

      double totalMinutes = 0.0;

      for (final entry in _allWorkedDurations) {
        if (entry.date.isAfter(lastDayOfMonth) || entry.date.isBefore(firstDayOfMonth)) continue;

        totalMinutes += entry.duration.inMinutes;
      }

      double totalHours = totalMinutes / 60.0;
      monthlyTotals.add(double.parse(totalHours.toStringAsFixed(1))); // 1 decimal
    }

    return monthlyTotals;
  }


  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
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
    for (final entry in _allWorkedDurations) {
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
