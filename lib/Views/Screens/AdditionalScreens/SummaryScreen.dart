import 'package:codex_clock/ViewModels/Summary_ViewModel.dart';
import 'package:codex_clock/ViewModels/UserData_ViewModel.dart';
import 'package:codex_clock/Views/Screens/AdditionalScreens/AttendenceScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../ViewModels/CompanyData_ViewModel.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final companyModel = Provider.of<CompanyDataViewModel>(context, listen: true);
    final userModel = Provider.of<UserDataViewModel>(context, listen: true);
    final size = MediaQuery.of(context).size;

    final createdAtDate = userModel.createdAt.toDate();

    final createdAtOnlyDate = DateTime(
      createdAtDate.year,
      createdAtDate.month,
      createdAtDate.day,
    );
    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 245, 248, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 5),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new_sharp),
                    ),
                    const Spacer(),
                    const Text(
                      "Summary",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 60),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Toggle Buttons
                    Consumer<SummaryViewModel>(
                        builder: (context, model, child) {
                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                _toggleButton("Weekly", 0, model),
                                _toggleButton("Monthly", 1, model),
                                _toggleButton("Yearly", 2, model),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Summary Card
                          if (model.selectedTab == 0)
                            _summaryCard("Weekly Summary", '${companyModel.weeklyHours['hour']}:${companyModel.weeklyHours['mint']}', model.formatDuration(model.getWeeklyWorkedHours(DateTime.now()))),
                          if (model.selectedTab == 1)
                            _summaryCard("Monthly Summary", '${companyModel.monthlyHours['hour']}:${companyModel.monthlyHours['mint']}', model.formatDuration(model.getMonthlyWorkedHours(DateTime.now()))),
                          if (model.selectedTab == 2)
                            _summaryCard("Yearly Summary", '${companyModel.yearlyHours['hour']}:${companyModel.yearlyHours['mint']}', model.formatDuration(model.getYearlyWorkedHours(DateTime.now()))),
                        ],
                      );
                      }
                    ),

                    const SizedBox(height: 10),

                    // Date Label and Month Navigator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Date*",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(236, 0, 60, 1),
                          ),
                        ),
                        Consumer<SummaryViewModel>(builder: (context, model, child) {
                          return Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.chevron_left),
                                  onPressed: model.previousMonth,
                                ),
                                Text(
                                  DateFormat.yMMMM().format(model.focusedDay),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.chevron_right),
                                  onPressed: model.nextMonth,
                                ),
                              ],
                            );
                        })
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Calendar
                    Consumer<SummaryViewModel>(builder: (context, model, child) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: TableCalendar(

                            firstDay: DateTime(2025, 1, 1),
                            lastDay: DateTime(2030, 12, 31),
                            focusedDay: model.focusedDay,
                            calendarFormat: CalendarFormat.month,
                            headerVisible: false,
                            rowHeight: size.height * 0.08,
                            selectedDayPredicate: (day) => false,

                            calendarBuilders: CalendarBuilders(
                              defaultBuilder: (context, day, focusedDay) {
                                final String formattedDay = day.day < 10 ? "0${day.day}" : "${day.day}";

                                if (isSameDay(day, DateTime.now())) {
                                  return _calendarDayWidget(
                                    formattedDay,
                                    Colors.blue,
                                        Colors.white,
                                        () => _onDateSelected(context, day),
                                  );
                                }

                                if (day.isBefore(DateTime.now())) {
                                  return model.attendanceRecords.containsKey(DateFormat('dd-MM-yyyy').format(day))
                                      ? _calendarDayWidget(
                                    formattedDay,
                                    const Color.fromRGBO(0, 239, 64, 1),
                                    Colors.white,// Green = Present
                                        () => _onDateSelected(context, day),
                                  )
                                      : day.isBefore(createdAtOnlyDate)
                                      ? _calendarDayWidget(
                                    formattedDay,
                                    Colors.transparent,
                                    Colors.grey.shade700,// Red = Absent
                                        () => {},
                                    )
                                      : _calendarDayWidget(
                                    formattedDay,
                                    const Color.fromRGBO(236, 0, 60, 1),
                                    Colors.white,// Red = Absent
                                        () => _onDateSelected(context, day),
                                  );
                                }

                                return GestureDetector(
                                  onTap: () => _onDateSelected(context, day),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      formattedDay,
                                      style: const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    })
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  void _onDateSelected(BuildContext context, DateTime selectedDate) {
    if (selectedDate.isBefore(DateTime.now())) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AttendanceScreen()),
      );
    }
  }

  Widget _summaryCard(String title, String requiredHours, String workedHours) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _summaryItem("Hours Required", requiredHours),
                _summaryItem("Hours Worked", workedHours),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleButton(String text, int index, SummaryViewModel model) {
    return Expanded(
      child: GestureDetector(
        onTap: () => model.setSelectedTab(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: model.selectedTab == index ? const Color.fromRGBO(236, 0, 60, 1) : Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: model.selectedTab == index ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _summaryItem(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _calendarDayWidget(String dayText, Color color, Color textColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Text(
          dayText,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

}