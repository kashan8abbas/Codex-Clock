import 'dart:async';

import 'package:codex_clock/Services/app_service.dart';
import 'package:codex_clock/Services/user_service.dart';
import 'package:codex_clock/ViewModels/Home_ViewModel.dart';
import 'package:codex_clock/ViewModels/Navigation_ViewModel.dart';
import 'package:codex_clock/ViewModels/Summary_ViewModel.dart';
import 'package:codex_clock/ViewModels/UserData_ViewModel.dart';
import 'package:codex_clock/Views/Screens/AdditionalScreens/ProfileScreen.dart';
import 'package:codex_clock/Views/Screens/HomePages/QR_CodeScreen.dart';
import 'package:codex_clock/Views/Widgets/CustomDrawer.dart';
import 'package:codex_clock/Views/Widgets/CustomNavbar.dart';
import 'package:codex_clock/Views/Widgets/CustomTimeCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../Services/internet_connectivity.dart';
import '../../../ViewModels/CompanyData_ViewModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String currentTime = '';
  int _selectedTabIndex = 0;
  final List<String> _tabs = ["Weekly", "Monthly", "Yearly"];


  Timer? _timer;

  void updateTime() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        currentTime = DateFormat('hh:mm:ss a').format(DateTime.now());
      });
    });
  }


  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  void _onItemTapped(int index) {
    final viewModel = Provider.of<NavigationViewModel>(context, listen: false);
    viewModel.updateIndex(index);

    if (viewModel.currentIndex == 2) {
      _scaffoldKey.currentState?.openEndDrawer();
    }
  }

  @override
  void initState() {
    super.initState();
    ConnectivityHelper.listenToConnectivityChanges(context);
    final userDataViewModel = Provider.of<UserDataViewModel>(context, listen: false);
    fetchUserData(userDataViewModel);
    final companyDataViewModel = Provider.of<CompanyDataViewModel>(context, listen: false);
    final summaryViewModel = Provider.of<SummaryViewModel>(context, listen: false);
    final homeViewmodel = Provider.of<HomeViewmodel>(context, listen: false);
    fetchChartData(summaryViewModel, homeViewmodel);
    UserService().isConnectedToCompanyWiFi();
    fetchCompanyData(companyDataViewModel);
    updateTime();
  }

  void fetchUserData(UserDataViewModel userDataViewModel) {
    UserService().fetchCurrentUserData().then((userData) {
      if(userData != null) {
        userDataViewModel.updateUserData(
            userData["uid"],
            userData["firstName"],
            userData["lastName"],
            userData["cnic"],
            userData["phone"],
            userData["email"],
            userData["position"],
            userData["dateOfBirth"],
            userData["gender"],
            userData["permanentAddress"],
            userData["currentAddress"],
            userData["dateOfJoining"],
            userData["profilePic"],
            userData["createdAt"],
            userData["status"]
        );
      }
    });
  }

  void fetchCompanyData(CompanyDataViewModel viewModel) async {
    AppService appService = AppService();
    await appService.fetchCompanyCode().then((companyData) {
      if(companyData != null) {
        viewModel.updateCompanyCode(companyData['code']);
      }
    });
    await appService.fetchCompanyWiFi().then((companyWiFi) {
      if(companyWiFi != null) {
        viewModel.updateCompanyIP(companyWiFi['ip_subnet']);
      }
    });
  }

  void fetchChartData(SummaryViewModel model, HomeViewmodel homeViewmodel) async {
    await UserService().loadAttendanceRecords(model).then((_) {
      List<double> days = model.getDailyWorkedHours(DateTime.now());
      homeViewmodel.setFetchDataDaily(days);
      List<double> weeks = model.getWeeklyWorkedHoursTotalsForMonth(DateTime.now().year, DateTime.now().month);
      homeViewmodel.setFetchDataWeek(weeks);
      List<double> year = model.getMonthlyWorkedHoursTotalsForYear(DateTime.now().year);
      homeViewmodel.setFetchDataYear(year);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userDataViewModel = Provider.of<UserDataViewModel>(context, listen: true);
    final navigationViewModel = Provider.of<NavigationViewModel>(context, listen: true);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color.fromRGBO(246, 245, 248, 1),
      endDrawer: const CustomDrawer(),
      body:
      navigationViewModel.currentIndex == 0 || navigationViewModel.currentIndex == 2
              ? Stack(
                children: [
                  // Scrollable content
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          SizedBox(height: 100),
                          TimeCardWidget(),
                          const SizedBox(height: 10),
                          _buildLeaveBalance(),
                          const SizedBox(height: 10),
                          _buildChartSection(),
                        ],
                      ),
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
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
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

                            const Spacer(),

                            Text(
                              "${userDataViewModel.firstName} ${userDataViewModel.lastName}",
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
              )
              : navigationViewModel.currentIndex == 1
              ? QRScannerBody()
              : Text("hello world"),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: navigationViewModel.currentIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildLeaveBalance() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8, // Adds a default shadow effect
      shadowColor: Colors.black.withOpacity(0.5), // Customize shadow color
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

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio:
                  1.95, // Adjust this value to control width & height ratio
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
      color: Colors.white,
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<HomeViewmodel>(builder: (context, model, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Styled Radio Buttons as Tabs
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(
                    246,
                    245,
                    248,
                    1,
                  ), // Background color
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: List.generate(
                      _tabs.length,
                          (index) => Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTabIndex = index;
                            });
                          },
                          child: Container(
                            height: 35,
                            width: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color:
                                _selectedTabIndex == index
                                    ? Color.fromRGBO(236, 0, 60, 1) // Selected tab background
                                    : Colors.transparent,
                              ),
                              color:
                              _selectedTabIndex == index
                                  ? Colors
                                  .white // Selected tab background
                                  : Colors
                                  .transparent, // Unselected tab background
                              borderRadius: BorderRadius.circular(
                                10,
                              ), // Smooth edges
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              _tabs[index],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:
                                _selectedTabIndex == index
                                    ? Colors
                                    .black // Dark text for selected
                                    : Colors.black.withOpacity(
                                  0.5,
                                ), // Faded text for unselected
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Bar Chart
              _selectedTabIndex == 0
                  ?  model.fetchDataDaily.isNotEmpty ? SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine:
                          (value) => FlLine(color: Colors.grey, strokeWidth: 1.2),
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            List<String> days = [
                              "Mon",
                              "Tue",
                              "Wed",
                              "Thu",
                              "Fri",
                            ];
                            return value.toInt() >= 0 &&
                                value.toInt() < days.length
                                ? Text(
                              days[value.toInt()],
                              style: const TextStyle(fontSize: 12),
                            )
                                : Container();
                          },
                        ),
                      ),
                    ),
                    barGroups: List.generate(
                      5,
                          (index) => _buildBarGroup(
                        index,
                        model.fetchDataDaily[_selectedTabIndex]![index],
                        index % 2 == 0 ? Colors.red : Colors.pink.shade300,
                      ),
                    ),
                  ),
                ),
              ) : SizedBox(
                height: 200,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: const SpinKitCircle(color: Color.fromRGBO(236, 0, 60, 1),size: 50),
                  ))
                  : _selectedTabIndex == 1
                  ? model.fetchDataWeek.isNotEmpty ? SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine:
                          (value) => FlLine(color: Colors.grey, strokeWidth: 1.2),
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            List<String> days = [
                              "First",
                              "Second",
                              "Third",
                              "Fourth",
                            ];
                            return value.toInt() >= 0 &&
                                value.toInt() < days.length
                                ? Text(
                              days[value.toInt()],
                              style: const TextStyle(fontSize: 12),
                            )
                                : Container();
                          },
                        ),
                      ),
                    ),
                    barGroups: List.generate(
                      4,
                          (index) => _buildBarGroup(
                        index,
                        model.fetchDataWeek[_selectedTabIndex]![index],
                        index % 2 == 0 ? Colors.red : Colors.pink.shade300,
                      ),
                    ),
                  ),
                ),
              ) : SizedBox(
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: const SpinKitCircle(color: Color.fromRGBO(236, 0, 60, 1),size: 50),
                  ))
                  : model.fetchDataYear.isNotEmpty ? SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine:
                          (value) => FlLine(color: Colors.grey, strokeWidth: 1.2),
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          // reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            List<String> days = [
                              "Jan",
                              "Feb",
                              "Mar",
                              "Apr",
                              "May",
                              "Jun",
                              "Jul",
                              "Aug",
                              "Sep",
                              "Oct",
                              "Nov",
                              "Dec",
                            ];
                            return value.toInt() >= 0 &&
                                value.toInt() < days.length
                                ? Text(
                              days[value.toInt()],
                              style: const TextStyle(fontSize: 9),
                            )
                                : Container();
                          },
                        ),
                      ),
                    ),
                    barGroups: List.generate(
                      12,
                          (index) => _buildBarGroup(
                        index,
                        model.fetchDataYear[_selectedTabIndex]![index],
                        index % 2 == 0 ? Colors.red : Colors.pink.shade300,
                      ),
                    ),
                  ),
                ),
              ) : SizedBox(
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: const SpinKitCircle(color: Color.fromRGBO(236, 0, 60, 1),size: 50),
                  )),
            ],
          );
        })
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        _selectedTabIndex != 2 ? BarChartRodData(

          toY: y,
          color: color,
          width: 30,
          borderRadius: BorderRadius.circular(5),
        ) : BarChartRodData(

          toY: y,
          color: color,
          width: 17,
          borderRadius: BorderRadius.circular(5),
        ),
      ],
    );
  }
}

// ignore: unused_element
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
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;

        return TextButton(
          onPressed: () {},
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05, // Adjust padding based on width
                vertical: height * 0.1, // Adjust padding based on height
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        value,
                        style: TextStyle(
                          fontSize:
                              width * 0.1, // Adjust text size based on width
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        icon,
                        color: Colors.black,
                        size: width * 0.08,
                      ), // Icon size based on width
                    ],
                  ),
                  SizedBox(height: height * 0.02), // Adjust spacing dynamically
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize:
                              width * 0.07, // Adjust text size based on width
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.black,
                        size: width * 0.103, // Adjust icon size based on width
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
