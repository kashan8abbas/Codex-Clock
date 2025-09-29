import 'package:codex_clock/ViewModels/UserData_ViewModel.dart';
import 'package:codex_clock/Views/Screens/AdditionalScreens/CorrectionRequestScreen.dart';
import 'package:codex_clock/Views/Screens/AdditionalScreens/LeaveScreen.dart';
import 'package:codex_clock/Views/Screens/AdditionalScreens/SummaryScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Screens/AdditionalScreens/SalaryScreen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  Future<void> logoutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      print("User logged out ✅");
    } catch (e) {
      print("Error while logging out ❌: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    final userDataViewModel = Provider.of<UserDataViewModel>(context, listen: true);
    return Drawer(
      backgroundColor: const Color.fromRGBO(246, 245, 248, 1),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(userDataViewModel.profilePic),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userDataViewModel.firstName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          userDataViewModel.position,
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        Text(
                          "Since ${userDataViewModel.dateOfJoining['day']} ${userDataViewModel.dateOfJoining['month']} ${userDataViewModel.dateOfJoining['year']}",
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10,),
              // Menu items with card-like appearance
              TextButton(
                onPressed: () {
                  // Navigate to a specific page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SummaryScreen()),
                  );
                },
                child: _buildMenuItem("Summary"),
              ),
              const SizedBox(height: 5),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ApplyLeaveScreen()),
                  );
                },
                child: _buildMenuItem("Leave Requests"),
              ),
              const SizedBox(height: 5),
              TextButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SalaryScreen()));
              },
                  child: _buildMenuItem("Salary")),

              const SizedBox(height: 5),
              TextButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CorrectionRequestScreen()));
              },
                  child: _buildMenuItem("Correction Request")),

              const SizedBox(height: 5),
              TextButton(onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                      (Route<dynamic> route) => false,
                );

                userDataViewModel.clearData();
                logoutUser();
              },
                  child: _buildMenuItem("Logout")),

              const Spacer(),

              // Back icon at the left bottom
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
