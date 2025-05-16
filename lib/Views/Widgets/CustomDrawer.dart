import 'package:codex_clock/ViewModels/UserData_ViewModel.dart';
import 'package:codex_clock/Views/Screens/AdditionalScreens/LeaveScreen.dart';
import 'package:codex_clock/Views/Screens/AdditionalScreens/SummaryScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userDataViewModel = Provider.of<UserDataViewModel>(context, listen: true);
    String month = '';
    switch (userDataViewModel.createdAt.toDate().month) {
      case 1:
        month = 'Jan';
        break;
      case 2:
        month = 'Feb';
        break;
      case 3:
        month = 'Mar';
        break;
      case 4:
        month = 'Apr';
        break;
      case 5:
        month = 'May';
        break;
      case 6:
        month = 'Jun';
        break;
      case 7:
        month = 'Jul';
        break;
      case 8:
        month = 'Aug';
        break;
      case 9:
        month = 'Sep';
        break;
      case 10:
        month = 'Oct';
        break;
      case 11:
        month = 'Nov';
        break;
      case 12:
        month = 'Dec';
        break;
      default:
        month = 'Unknown';
    }
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
                          "Since ${userDataViewModel.createdAt.toDate().day} $month ${userDataViewModel.createdAt.toDate().year}",
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
              TextButton(onPressed: () {}, child: _buildMenuItem("Salary")),

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
