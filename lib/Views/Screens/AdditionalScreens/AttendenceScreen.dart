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
    {
      'date': '29 Wed',
      'checkIn': '10:00 AM',
      'checkOut': '04:00 PM',
      'hours': '07:00',
      'status': 'Early Leave',
      'type': 'Regular',
      'statusColor': Colors.orange,
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
    {
      'date': '29 Wed',
      'checkIn': '10:00 AM',
      'checkOut': '04:00 PM',
      'hours': '07:00',
      'status': 'Early Leave',
      'type': 'Regular',
      'statusColor': Colors.orange,
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
    {
      'date': '29 Wed',
      'checkIn': '10:00 AM',
      'checkOut': '04:00 PM',
      'hours': '07:00',
      'status': 'Early Leave',
      'type': 'Regular',
      'statusColor': Colors.orange,
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
    {
      'date': '29 Wed',
      'checkIn': '10:00 AM',
      'checkOut': '04:00 PM',
      'hours': '07:00',
      'status': 'Early Leave',
      'type': 'Regular',
      'statusColor': Colors.orange,
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
            return SafeArea(
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
                          "My Attendance",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(width: 60),
                      ],
                    ),
                  ),
                  SizedBox(height: 16,),
                  Container(
                    margin:EdgeInsets.symmetric(
                    horizontal: 10,
                    ) ,
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
                        Expanded(child: _filterButton("All", model)),
                        Expanded(child: _filterButton("Early Leave", model)),
                        Expanded(child: _filterButton("Absent", model)),
                        Expanded(child: _filterButton("Full Day", model)),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _filterButton(String type, AttendanceModel model) {
    return GestureDetector(
      onTap: () => model.setLeaveType(type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 1),
        decoration: BoxDecoration(
          color: model.selectedLeaveType == type ?  Color.fromRGBO(236, 0, 60, 1) : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            type,
            textAlign: TextAlign.center,
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
