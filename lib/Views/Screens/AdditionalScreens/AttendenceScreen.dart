import 'package:codex_clock/Services/user_service.dart';
import 'package:codex_clock/ViewModels/Attendence_ViewModel.dart';
import 'package:codex_clock/Views/Widgets/AttendenceCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {




  @override
  void initState() {
    super.initState();
    final attendanceViewmodel = Provider.of<AttendanceViewModel>(context, listen: false);
    attendanceViewmodel.fetchRecords(DateTime.now().month);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(246, 245, 248, 1),
      body: Consumer<AttendanceViewModel>(
        builder: (context, model, child) {
          final filteredData = model.filterAttendance(model.data);
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
                GestureDetector(
                  onTap: _showMonthPickerDialog,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${model.months[model.selectedMonth]} ${model.selectedYear}',
                          style: const TextStyle(
                            color: Colors.pink,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.calendar_today,
                          color: Colors.pink,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),

                //const SizedBox(height: 25),
                const SizedBox(height: 10),

                // Attendance List
                Expanded(
                  child: model.data.isNotEmpty ? filteredData.isNotEmpty ? ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      return AttendanceCard(data: filteredData[index]);
                    },
                  ) : Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: const Text('No Data Available', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),),
                  ) : Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: const SpinKitCircle(color: Color.fromRGBO(236, 0, 60, 1),size: 50),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _filterButton(String type, AttendanceViewModel model) {
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

  void _showMonthPickerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final model = Provider.of<AttendanceViewModel>(context, listen: false);
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Select Month', style: TextStyle(color: Color.fromRGBO(236, 0, 60, 1),fontWeight: FontWeight.bold),),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 12,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${model.months[index]} ${model.selectedYear}'),
                  onTap: () {
                    model.setMonth(index);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }


}
