import 'package:codex_clock/ViewModels/Leave_ViewModel.dart';
import 'package:codex_clock/Views/Widgets/BottomSheet.dart';
import 'package:codex_clock/Views/Widgets/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class ApplyLeaveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ApplyLeaveViewModel(),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(246, 245, 248, 1),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16, top: 130),
              child: Consumer<ApplyLeaveViewModel>(
                builder: (context, model, child) {
                  return SingleChildScrollView(
                    child: Container(
                      height:
                          MediaQuery.of(
                            context,
                          ).size.height, // Take full screen height
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Type of leave*",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8),
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
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _leaveTypeButton("Casual", model),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: _leaveTypeButton("Sick", model),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 26),
                          Text(
                            "Date*",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TableCalendar(
                              firstDay: DateTime.utc(2020, 1, 1),
                              lastDay: DateTime.utc(2030, 12, 31),
                              focusedDay: model.selectedDate,
                              selectedDayPredicate:
                                  (day) => isSameDay(model.selectedDate, day),
                              onDaySelected: (selectedDay, focusedDay) {
                                model.setSelectedDate(selectedDay);
                              },
                              headerStyle: HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true,
                                titleTextFormatter:
                                    (date, locale) =>
                                        '${DateFormat.MMMM(locale).format(date)} ${date.year}',
                                titleTextStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 26),
                          Text(
                            "Note",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: TextField(
                              maxLines: 2,
                              decoration: InputDecoration(
                                hintText: "Write a reason",
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) => model.setNote(value),
                            ),
                          ),

                          // Push the button to the end
                          SizedBox(height: 50),
                          CustomButton(
                            text: "Apply",
                            color: const Color.fromRGBO(236, 0, 60, 1),
                            onPressed: () {
                              //model.submitLeave();
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder:
                                    (context) => LeaveBottomSheet(
                                      title: "Request Pending",
                                      progressValue: 1,
                                      description:
                                          "Your request has been received and we will let you know as soon as possible.",
                                      buttonText: "Back to Home",
                                    ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
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
                        "Apply Leave",
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
        ),
      ),
    );
  }

  Widget _leaveTypeButton(String type, ApplyLeaveViewModel model) {
    return Expanded(
      child: GestureDetector(
        onTap: () => model.setLeaveType(type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: model.selectedLeaveType == type ? Colors.red : Colors.white,
            borderRadius: BorderRadius.circular(8),
            //border: Border.all(color: Colors.red),
          ),
          child: Center(
            child: Text(
              type,
              style: TextStyle(
                color:
                    model.selectedLeaveType == type
                        ? Colors.white
                        : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
