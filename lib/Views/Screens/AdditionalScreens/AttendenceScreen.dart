import 'package:codex_clock/ViewModels/Attendence_ViewModel.dart';
import 'package:codex_clock/Views/Widgets/AttendenceCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttendanceScreen extends StatelessWidget {
  final List<Map<String, dynamic>> attendanceData = [
    {
      'date': '31 Fri',
      'checkIn': '10:00 AM',
      'checkOut': '06:00 PM',
      'hours': '09:00',
      'status': 'Full Day',
      'type': 'Regular',
      'statusColor': Colors.green,
    },
    {
      'date': '30 Thu',
      'checkIn': '10:00 AM',
      'checkOut': '--:--',
      'hours': '--:--',
      'status': 'Absent',
      'type': 'Regular',
      'statusColor': Colors.red,
    },
    {
      'date': '29 Wed',
      'checkIn': '10:00 AM',
      'checkOut': '04:00 PM',
      'hours': '07:00',
      'status': 'Early Leave',
      'type': 'Regular',
      'statusColor': Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AttendanceModel(),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(246, 245, 248, 1),
        body: Consumer<AttendanceModel>(
          builder: (context, model, child) {
            final filteredData = model.filterAttendance(attendanceData);
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 130.0,
                    horizontal: 16,
                  ),
                  child: Column(
                    children: [
                      // Filter Buttons
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
                            Expanded(child: _FilterButton("All", model)),
                            Expanded(
                              child: _FilterButton("Early Leave", model),
                            ),
                            Expanded(child: _FilterButton("Absent", model)),
                            Expanded(child: _FilterButton("Full Day", model)),
                          ],
                        ),
                      ),
                      // Month & Calendar Icon
                      SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'January 2025',
                              style: TextStyle(
                                color: Colors.pink,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.calendar_today,
                              color: Colors.pink,
                              size: 20,
                            ),
                          ],
                        ),
                      ),

                      //const SizedBox(height: 25),
                      const SizedBox(height: 10),

                      // Attendance List
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredData.length,
                          itemBuilder: (context, index) {
                            return AttendanceCard(data: filteredData[index]);
                          },
                        ),
                      ),
                      // Weekend Off Section
                      Container(
                        color: Colors.pink.shade100,
                        padding: const EdgeInsets.all(12),
                        child: const Text(
                          'Weekend Off  25 Saturday 26 Sunday',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                          textAlign: TextAlign.center,
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
                    color: Color.fromRGBO(246, 245, 248, 1),
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
                            "My Attendance",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(width: 60),
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

  Widget _FilterButton(String type, AttendanceModel model) {
    return GestureDetector(
      onTap: () => model.setLeaveType(type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: model.selectedLeaveType == type ? Colors.red : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            type,
            style: TextStyle(
              color:
                  model.selectedLeaveType == type ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
