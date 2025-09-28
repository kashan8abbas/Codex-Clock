import 'package:codex_clock/ViewModels/CorrectionRequestViewModel.dart';
import 'package:codex_clock/ViewModels/UserData_ViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Services/add_notification_service.dart';
import '../../../Services/push_notification_service.dart';
import '../../../Services/user_service.dart';
import '../../../Utils/Utilities.dart';
import '../../../ViewModels/Loading_ViewModel.dart';
import '../../../ViewModels/admin_fcmtoken.dart';
import '../../Widgets/BottomSheet.dart';
import '../../Widgets/CustomButton.dart';
import '../../Widgets/CustomDropdown.dart';
import '../../Widgets/CustomLabel.dart';

class CorrectionRequestScreen extends StatefulWidget {
  const CorrectionRequestScreen({super.key});

  @override
  State<CorrectionRequestScreen> createState() => _CorrectionRequestScreenState();
}

class _CorrectionRequestScreenState extends State<CorrectionRequestScreen> {

  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    final loadingViewModel = Provider.of<LoadingViewModel>(context, listen: true);
    final adminTokenViewModel = Provider.of<AdminFcmTokenViewModel>(context, listen: true);
    final userViewModel = Provider.of<UserDataViewModel>(context, listen: true);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 245, 248, 1),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Consumer<CorrectionRequestViewModel>(builder: (context, viewModel, child)
            {
             return Column(
               crossAxisAlignment: CrossAxisAlignment.start,
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
                         "Correction Request",
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

                 SizedBox(height: 20,),

                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 20),
                   child: const CustomLabel(text: "Date "),
                 ),
                 const SizedBox(height: 5),
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 15),
                   child: Row(
                     children: [
                       Expanded(
                         child: CustomDropdown(
                           items: List.generate(
                             31,
                                 (index) => (index + 1).toString().length == 1 ? '0${(index + 1).toString()}' : (index + 1).toString(),
                           ),
                           selectedValue: viewModel.selectedDay,
                           onChanged:
                               (value) {
                             viewModel.setDate(
                               value!,
                               viewModel.selectedMonth ?? "",
                               viewModel.selectedYear ?? "",
                             );
                           },
                           text: Text('Day', style: TextStyle(color: Colors.grey, fontSize: 14),),
                           errorText: viewModel.dayError,
                         ),
                       ),
                       const SizedBox(width: 10),
                       Expanded(
                         child: CustomDropdown(
                           items: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
                           selectedValue: viewModel.selectedMonth,
                           onChanged:
                               (value) => viewModel.setDate(
                             viewModel.selectedDay ?? "",
                             value!,
                             viewModel.selectedYear ?? "",
                           ),
                           text: Text('Month', style: TextStyle(color: Colors.grey, fontSize: 14),),
                           errorText: viewModel.monthError,
                         ),
                       ),
                       const SizedBox(width: 10),
                       Expanded(
                         child: CustomDropdown(
                           items: List.generate(
                             50,
                                 (index) => (2025 - index).toString(),
                           ),
                           selectedValue: viewModel.selectedYear,
                           onChanged:
                               (value) {
                             viewModel.setDate(
                               viewModel.selectedDay ?? "",
                               viewModel.selectedMonth ?? "",
                               value!,
                             );
                           },
                           text: Text('Year', style: TextStyle(color: Colors.grey, fontSize: 14),),
                           errorText: viewModel.yearError,
                         ),
                       ),
                     ],
                   ),
                 ),

                 SizedBox(height: 20,),

                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 20),
                   child: const CustomLabel(text: "Check In "),
                 ),
                 const SizedBox(height: 5),
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 15),
                   child: Row(
                     children: [
                       Expanded(
                         child: CustomDropdown(
                           items: List.generate(
                             12,
                                 (index) => (index + 1).toString().length == 1 ? '0${(index + 1).toString()}' : (index + 1).toString(),
                           ),
                           selectedValue: viewModel.selectedCheckInHour,
                           onChanged:
                               (value) {
                             viewModel.setCheckInTime(
                               value!,
                               viewModel.selectedCheckInMint ?? "",
                               viewModel.selectedCheckInPeriod ?? "",
                             );
                           },
                           text: Text('Hour', style: TextStyle(color: Colors.grey, fontSize: 14),),
                           errorText: viewModel.selectedCheckInHourError,
                         ),
                       ),
                       const SizedBox(width: 10),
                       Expanded(
                         child: CustomDropdown(
                           items: List.generate(
                             59,
                                 (index) => (index + 1).toString().length == 1 ? '0${(index + 1).toString()}' : (index + 1).toString(),
                           )..add("00"),
                           selectedValue: viewModel.selectedCheckInMint,
                           onChanged:
                               (value) {
                             viewModel.setCheckInTime(
                               viewModel.selectedCheckInHour ?? "",
                               value!,
                               viewModel.selectedCheckInPeriod ?? "",
                             );
                           },
                           text: Text('Minutes', style: TextStyle(color: Colors.grey, fontSize: 14),),
                           errorText: viewModel.selectedCheckInMintError,
                         ),
                       ),
                       const SizedBox(width: 10),
                       Expanded(
                         child: CustomDropdown(
                           items: ['AM', 'PM'],
                           selectedValue: viewModel.selectedCheckInPeriod,
                           onChanged:
                               (value) {
                             viewModel.setCheckInTime(
                               viewModel.selectedCheckInHour ?? "",
                               viewModel.selectedCheckInMint ?? "",
                               value!,
                             );
                           },
                           text: Text('Period', style: TextStyle(color: Colors.grey, fontSize: 14),),
                           errorText: viewModel.selectedCheckInPeriodError,
                         ),
                       ),
                     ],
                   ),
                 ),

                 SizedBox(height: 20,),

                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 20),
                   child: const CustomLabel(text: "Check Out "),
                 ),
                 const SizedBox(height: 5),
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 15),
                   child: Row(
                     children: [
                       Expanded(
                         child: CustomDropdown(
                           items: List.generate(
                             12,
                                 (index) => (index + 1).toString().length == 1 ? '0${(index + 1).toString()}' : (index + 1).toString(),
                           ),
                           selectedValue: viewModel.selectedCheckOutHour,
                           onChanged:
                               (value) {
                             viewModel.setCheckOutTime(
                               value!,
                               viewModel.selectedCheckOutMint ?? "",
                               viewModel.selectedCheckOutPeriod ?? "",
                             );
                           },
                           text: Text('Hour', style: TextStyle(color: Colors.grey, fontSize: 14),),
                           errorText: viewModel.selectedCheckOutHourError,
                         ),
                       ),
                       const SizedBox(width: 10),
                       Expanded(
                         child: CustomDropdown(
                           items: List.generate(
                             59,
                                 (index) => (index + 1).toString().length == 1 ? '0${(index + 1).toString()}' : (index + 1).toString(),
                           )..add("00"),
                           selectedValue: viewModel.selectedCheckOutMint,
                           onChanged:
                               (value) {
                             viewModel.setCheckOutTime(
                               viewModel.selectedCheckOutHour ?? "",
                               value!,
                               viewModel.selectedCheckOutPeriod ?? "",
                             );
                           },
                           text: Text('Minutes', style: TextStyle(color: Colors.grey, fontSize: 14),),
                           errorText: viewModel.selectedCheckOutMintError,
                         ),
                       ),
                       const SizedBox(width: 10),
                       Expanded(
                         child: CustomDropdown(
                           items: ['AM', 'PM'],
                           selectedValue: viewModel.selectedCheckOutPeriod,
                           onChanged:
                               (value) {
                             viewModel.setCheckOutTime(
                               viewModel.selectedCheckOutHour ?? "",
                               viewModel.selectedCheckOutMint ?? "",
                               value!,
                             );
                           },
                           text: Text('Period', style: TextStyle(color: Colors.grey, fontSize: 14),),
                           errorText: viewModel.selectedCheckOutPeriodError,
                         ),
                       ),
                     ],
                   ),
                 ),
                 SizedBox(height: 20,),

                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 15),
                   child: CustomLabel(text: 'Note')
                 ),
                 SizedBox(height: 5),
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 15),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Container(
                         decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.circular(15),
                         ),
                         child: TextField(
                           maxLines: 2,
                           decoration: InputDecoration(
                             hintText: "Write a reason",
                             hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                             border: OutlineInputBorder(
                               borderRadius: BorderRadius.all(Radius.circular(10))
                             ), // optional, used as default
                             enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                               borderSide: BorderSide(
                                 color: const Color.fromRGBO(236, 0, 60, 1), // 🔴 change to your desired color
                                 width: 1.0,
                               ),
                             ),
                             focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                               borderSide: BorderSide(
                                 color: const Color.fromRGBO(236, 0, 60, 1), // color when the field is focused
                                 width: 2.0,
                               ),
                             ),
                           ),
                           onChanged: (value) => viewModel.setNote(value),
                         ),

                       ),
                       if (viewModel.noteError != null) ...[
                         const SizedBox(height: 4),
                         Text(
                           viewModel.noteError!,
                           style: const TextStyle(color: Colors.red, fontSize: 12),
                         ),
                       ],
                     ],
                   ),
                 ),
                 SizedBox(height: 16),

                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 15),
                   child: CustomButton(
                     text: "Apply",
                     color: const Color.fromRGBO(236, 0, 60, 1),
                     onPressed: () {
                       if(viewModel.validateForm()) {
                         loadingViewModel.setLoading(true);
                         _userService.applyCorrectionRequest(
                             viewModel.note,
                             {
                               'day': viewModel.selectedDay,
                               'month': viewModel.selectedMonth,
                               'year': viewModel.selectedYear
                             },
                           {
                             'hour': viewModel.selectedCheckInHour,
                             'mints': viewModel.selectedCheckInMint,
                             'period': viewModel.selectedCheckInPeriod
                           },
                           {
                             'hour': viewModel.selectedCheckOutHour,
                             'mints': viewModel.selectedCheckOutMint,
                             'period': viewModel.selectedCheckOutPeriod
                           },
                         ).then((_) {
                           PushNotificationService().sendNotification(adminTokenViewModel.adminToken, 'Correction Request', 'Correction Request From ${userViewModel.firstName}').then((_) {
                             AdminNotificationService().addNotification(title: 'Correction Request', description: 'Correction Request From ${userViewModel.firstName}', userName: '${userViewModel.firstName} ${userViewModel.lastName}', userImage: userViewModel.profilePic, userId: userViewModel.uid);
                           });
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
                     },
                   ),
                 ),





                 // Fixed Top Bar

               ],
             );
            }
          )
        ),
      ),
    );
  }
}
