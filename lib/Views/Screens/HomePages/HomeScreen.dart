import 'package:codex_clock/Views/Widgets/CustomNavbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 245, 248, 1),

      body:
          _selectedIndex == 0
              ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 100,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Profile (Profile Button)
                              IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/profile');
                                },
                                icon: SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: ClipOval(
                                    child: SvgPicture.asset(
                                      "lib/Utils/Images/Logo.svg",
                                      width: 36,
                                      height: 36,
                                    ),
                                  ),
                                ),
                              ),

                              // Spacer to center the text
                              const Spacer(),

                              // Title
                              const Text(
                                "M Waleed",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),

                              // Spacer for balance
                              const Spacer(),

                              // Invisible button (to keep balance in spacing)
                              const SizedBox(width: 60),
                            ],
                          ),
                        ),
                      ),

                      _buildTimeCard(),
                      const SizedBox(height: 15),
                      _buildLeaveBalance(),
                      const SizedBox(height: 20),
                      //_buildChartSection(),
                    ],
                  ),
                ),
              )
              : _selectedIndex == 1
              ? Text("Scan")
              : _selectedIndex == 2
              ? Text("Drawer")
              : Text("hello world"),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildTimeCard() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "10:00 AM",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Jan 27 - 2025 Monday",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _IconText(icon: Icons.access_time, text: "10:00 AM\nCheck In"),
                _IconText(icon: Icons.logout, text: "06:00 PM\nCheck Out"),
                _IconText(icon: Icons.timer, text: "08:00\nTotal Hrs"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveBalance() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: const Text(
                "Leave Balance",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: const Text(
                "Current Month",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 0),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio:
                  2, // Adjust this value to control width & height ratio
              children: const [
                LeaveCard(title: "Sick Leave", value: "06", icon: Icons.group),
                LeaveCard(title: "Absent", value: "02", icon: Icons.group),
                LeaveCard(title: "Late in", value: "03", icon: Icons.group),
                LeaveCard(title: "Total Leave", value: "08", icon: Icons.group),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ChartTab(text: "Weekly", isSelected: true),
                _ChartTab(text: "Monthly"),
                _ChartTab(text: "Yearly"),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: Placeholder(), // Replace with actual chart
            ),
          ],
        ),
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String text;

  const _IconText({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.black),
        const SizedBox(height: 5),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: Colors.black),
        ),
      ],
    );
  }
}

class LeaveCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const LeaveCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Takes only the required height
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(icon, color: Colors.black),
                ],
              ),
              const SizedBox(height: 4), // Adjust spacing
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                    size: 25,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChartTab extends StatelessWidget {
  final String text;
  final bool isSelected;

  const _ChartTab({required this.text, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: isSelected ? Colors.red : Colors.black,
      ),
    );
  }
}
