
import 'package:codex_clock/ViewModels/UserData_ViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:codex_clock/Views/Widgets/CustomLabel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    super.initState();
  }
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

    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 245, 248, 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios),
                  ),
                  SizedBox(height: 1,)
                ],
              ),
            ),
            Center(
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color.fromRGBO(236, 0, 60, 1),
                    width: 2.5,
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    userDataViewModel.profilePic,
                    fit: BoxFit.cover,
                    width: 130,
                    height: 130,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Name Fields
            const CustomLabel(text: "Name"),
            _customContainer(Text("${userDataViewModel.firstName} ${userDataViewModel.lastName}", style: TextStyle(fontWeight: FontWeight.bold),)),
            const SizedBox(height: 10),

            const CustomLabel(text: "Designation"),
            _customContainer(Text(userDataViewModel.position, style: TextStyle(fontWeight: FontWeight.bold),)),
            const SizedBox(height: 10),

            const CustomLabel(text: "C.N.I.C"),
            _customContainer(Text(userDataViewModel.cnic, style: TextStyle(fontWeight: FontWeight.bold),)),
            const SizedBox(height: 10),

            const CustomLabel(text: "Date Of Birth"),
            _customContainer(
                Text(
                  int.parse(userDataViewModel.dateOfBirth['day']) < 10
                      ? '0${userDataViewModel.dateOfBirth['day']} - ${userDataViewModel.dateOfBirth['month']} - ${userDataViewModel.dateOfBirth['year']}'
                      : '${userDataViewModel.dateOfBirth['day']} - ${userDataViewModel.dateOfBirth['month']} - ${userDataViewModel.dateOfBirth['year']}', style: TextStyle(fontWeight: FontWeight.bold),)),
            const SizedBox(height: 10),

            const CustomLabel(text: "Mobile No"),
            _customContainer(Text(
              "0${userDataViewModel.phone}", style: TextStyle(fontWeight: FontWeight.bold),)),
            const SizedBox(height: 10),

            const CustomLabel(text: "Since"),
            _customContainer(Text("${userDataViewModel.createdAt.toDate().day} - $month - ${userDataViewModel.createdAt.toDate().year} ", style: TextStyle(fontWeight: FontWeight.bold),)),
          ],
        ),
      ),
    );
  }

  Widget _customContainer(Widget text) {
    return Container(
      height: 50,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color.fromRGBO(236, 0, 60, 1)) ,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Shadow color
            spreadRadius: 0.5,  // How much the shadow spreads
            blurRadius: 9,    // How soft the shadow is
            offset: Offset(0, 1), // Horizontal and vertical offset
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: text,
      ),
    );
  }
}
