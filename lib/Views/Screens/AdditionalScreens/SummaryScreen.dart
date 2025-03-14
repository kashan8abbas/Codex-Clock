import 'package:codex_clock/ViewModels/Summary_ViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SummaryViewModel(),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(246, 245, 248, 1),
        body: Consumer<SummaryViewModel>(
          builder: (context, model, child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 130,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Toggle Buttons
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(
                                0.3,
                              ), // Grey shadow with opacity
                              spreadRadius: 2, // How much the shadow spreads
                              blurRadius: 5, // Softness of the shadow
                              offset: Offset(
                                0,
                                3,
                              ), // Shadow position (horizontal, vertical)
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _toggleButton("Weekly", 0, model),
                            _toggleButton("Monthly", 1, model),
                            _toggleButton("Yearly", 2, model),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Dynamic Summary Card
                      if (model.selectedTab == 0)
                        _summaryCard("Weekly Summary", "40:00:00", "35:00:00"),
                      if (model.selectedTab == 1)
                        _summaryCard(
                          "Monthly Summary",
                          "160:00:00",
                          "150:00:00",
                        ),
                      if (model.selectedTab == 2)
                        _summaryCard(
                          "Yearly Summary",
                          "1920:00:00",
                          "1850:00:00",
                        ),

                      const SizedBox(height: 16),

                      // Date Picker and Calendar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Date*",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.chevron_left),
                                onPressed: model.previousMonth,
                              ),
                              Text(model.selectedMonth),
                              IconButton(
                                icon: const Icon(Icons.chevron_right),
                                onPressed: model.nextMonth,
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Expanded(
                        child: TableCalendar(
                          firstDay: DateTime(2020, 1, 1),
                          lastDay: DateTime(2030, 12, 31),
                          focusedDay: model.focusedDay,
                          calendarFormat: CalendarFormat.month,
                          headerVisible: false,
                          selectedDayPredicate:
                              (day) => isSameDay(model.focusedDay, day),
                          onDaySelected: (selectedDay, focusedDay) {
                            model.setFocusedDay(focusedDay);
                          },
                          calendarBuilders: CalendarBuilders(
                            defaultBuilder: (context, day, focusedDay) {
                              return _calendarDayWidget(day, model);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Fixed Top Bar
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    color: Color.fromRGBO(
                      246,
                      245,
                      248,
                      1,
                    ), // Add background color to prevent transparency issues
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back_ios_new_sharp),
                          ),

                          const Spacer(),

                          const Text(
                            "Summary",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),

                          const Spacer(),

                          const SizedBox(width: 60), // Keeps spacing balanced
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
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
            color: model.selectedTab == index ? Colors.red : Colors.white,
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

  Widget _calendarDayWidget(DateTime day, SummaryViewModel model) {
    Color? bgColor = model.getDayColor(day);
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          day.day.toString(),
          style: TextStyle(
            color: bgColor != null ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
