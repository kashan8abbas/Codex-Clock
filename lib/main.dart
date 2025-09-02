import 'package:codex_clock/ViewModels/Attendence_ViewModel.dart';
import 'package:codex_clock/ViewModels/CompanyData_ViewModel.dart';
import 'package:codex_clock/ViewModels/CorrectionRequestViewModel.dart';
import 'package:codex_clock/ViewModels/Home_ViewModel.dart';
import 'package:codex_clock/ViewModels/Leave_ViewModel.dart';
import 'package:codex_clock/ViewModels/Loading_ViewModel.dart';
import 'package:codex_clock/ViewModels/Navigation_ViewModel.dart';
import 'package:codex_clock/ViewModels/QRCode_ViewModel.dart';
import 'package:codex_clock/ViewModels/Register2_VIewModel.dart';
import 'package:codex_clock/ViewModels/Summary_ViewModel.dart';
import 'package:codex_clock/ViewModels/TakePhoto_ViewModel.dart';
import 'package:codex_clock/ViewModels/UserData_ViewModel.dart';
import 'package:codex_clock/Views/Screens/AuthScreens/EmailLoginScreen.dart';
import 'package:codex_clock/Views/Screens/AuthScreens/PhoneLoginScreen.dart';
import 'package:codex_clock/Views/Screens/HomePages/HomeScreen.dart';
import 'package:codex_clock/test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ViewModels/QRLoadingViewModel.dart';
import 'ViewModels/Salary_ViewModel.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool _isFirstTimeUser = true;

  @override
  void initState() {
    super.initState();
    _isFirstTimeUser = auth.currentUser == null;
    auth.authStateChanges().listen((user) {
      setState(() {
        _isFirstTimeUser = user == null;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CameraViewModel()),
        ChangeNotifierProvider(create: (_) => SignUpViewModel()),
        ChangeNotifierProvider(create: (_) => QRScannerViewModel()),
        ChangeNotifierProvider(create: (_) => ApplyLeaveViewModel()),
        ChangeNotifierProvider(create: (_) => AttendanceViewModel()),
        ChangeNotifierProvider(create: (_) => LoadingViewModel()),
        ChangeNotifierProvider(create: (_) => UserDataViewModel()),
        ChangeNotifierProvider(create: (_) => CompanyDataViewModel()),
        ChangeNotifierProvider(create: (_) => NavigationViewModel()),
        ChangeNotifierProvider(create: (_) => QRLoadingViewModel()),
        ChangeNotifierProvider(create: (_) => SummaryViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewmodel()),
        ChangeNotifierProvider(create: (_) => AttendanceViewModel()),
        ChangeNotifierProvider(create: (_) => SalaryViewModel()),
        ChangeNotifierProvider(create: (_) => CorrectionRequestViewModel()),

      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: RandomAttendanceScreen(),
        theme: ThemeData(
          textSelectionTheme: const TextSelectionThemeData(

            cursorColor: Color.fromRGBO(236, 0, 60, 1),          // Cursor color
            selectionColor: Color.fromRGBO(236, 0, 60, 1), // Selected text color
            selectionHandleColor: Color.fromRGBO(236, 0, 60, 1),

            // Drag handle (cursor drag color)
          ),
        ),
      ),
    );
  }
}
