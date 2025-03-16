import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SummaryViewModel extends ChangeNotifier {
  int selectedTab = 0;
  DateTime focusedDay = DateTime.now();

  Map<DateTime, Color> markedDates = {
    DateTime(2025, 1, 1): Colors.green,
    DateTime(2025, 1, 2): Colors.orange,
    DateTime(2025, 1, 3): Colors.red,
  };

  void setSelectedTab(int index) {
    selectedTab = index;
    notifyListeners();
  }

  //This function will work on database, this is implemented just as dummy for testing purposes.
  bool isPresent(DateTime day) {
    // Dummy condition for now
    return day.day % 2 == 0;
  }

  void setFocusedDay(DateTime day) {
    focusedDay = day;
    notifyListeners();
  }

  void previousMonth() {
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

  Color? getDayColor(DateTime day) {
    for (var date in markedDates.keys) {
      if (day.year == date.year &&
          day.month == date.month &&
          day.day == date.day) {
        return markedDates[date];
      }
    }
    return null;
  }
}
