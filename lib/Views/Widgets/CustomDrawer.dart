import 'package:codex_clock/Views/Screens/AdditionalScreens/SummaryScreen.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/profile.jpg'),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "M Waleed",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "Graphic Designer",
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        Text(
                          "Since 01 July 2024",
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        const SizedBox(height: 20),
                        const Divider(height: 1, thickness: 1),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ],
                ),
              ),

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
                onPressed: () {},
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
