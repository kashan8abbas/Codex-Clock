import 'package:codex_clock/Services/user_service.dart';
import 'package:codex_clock/Utils/Utilities.dart';
import 'package:codex_clock/ViewModels/Leave_ViewModel.dart';
import 'package:codex_clock/ViewModels/Loading_ViewModel.dart';
import 'package:codex_clock/Views/Widgets/BottomSheet.dart';
import 'package:codex_clock/Views/Widgets/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class ApplyLeaveScreen extends StatelessWidget {

  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    final loadingViewModel = Provider.of<LoadingViewModel>(context, listen: true);
    return ChangeNotifierProvider(
      create: (_) => ApplyLeaveViewModel(),
      child: Scaffold(
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
                        "Apply Leave",
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
                Consumer<ApplyLeaveViewModel>(
                  builder: (context, model, child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                          SizedBox(height: 16),

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
                              calendarStyle: CalendarStyle(
                                isTodayHighlighted: false,
                                selectedDecoration: BoxDecoration(
                                  color: const Color.fromRGBO(236, 0, 60, 1), // 🔴 change to any color you want
                                  shape: BoxShape.circle,
                                ),
                                selectedTextStyle: TextStyle(
                                  color: Colors.white, // text color on selected day
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),

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
                                border: OutlineInputBorder(), // optional, used as default
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: const Color.fromRGBO(236, 0, 60, 1), // 🔴 change to your desired color
                                    width: 2.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: const Color.fromRGBO(236, 0, 60, 1), // color when the field is focused
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              onChanged: (value) => model.setNote(value),
                            ),

                          ),
                          SizedBox(height: 16),

                          CustomButton(
                            text: "Apply",
                            color: const Color.fromRGBO(236, 0, 60, 1),
                            onPressed: () {
                              if(model.note.isNotEmpty) {
                                if(model.selectedDate.isAfter(DateTime.now())) {
                                  loadingViewModel.setLoading(true);
                                  _userService.applyLeave(model.note, model.selectedDate, model.selectedLeaveType).then((_) {
                                    loadingViewModel.setLoading(false);
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
                                  });
                                }
                                else {
                                  Utilities().errorMsg("Really Nigga");
                                }
                              }
                              else {
                                Utilities().errorMsg("Please Provide us a Reason for your Leave Request.");
                              }

                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
            
                // Fixed Top Bar
            
              ],
            ),
          ),
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
            color: model.selectedLeaveType == type ? const Color.fromRGBO(236, 0, 60, 1) : Colors.white,
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
