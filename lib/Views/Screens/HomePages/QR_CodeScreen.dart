import 'dart:convert';

import 'package:codex_clock/Services/app_service.dart';
import 'package:codex_clock/Services/user_service.dart';
import 'package:codex_clock/ViewModels/CompanyData_ViewModel.dart';
import 'package:codex_clock/ViewModels/Navigation_ViewModel.dart';
import 'package:codex_clock/ViewModels/QRLoadingViewModel.dart';
import 'package:codex_clock/Views/Screens/AuthScreens/TakePhotoScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../Widgets/SuccessDialogBox.dart';

class QRScannerBody extends StatefulWidget {
  const QRScannerBody({Key? key}) : super(key: key);

  @override
  State<QRScannerBody> createState() => _QRScannerBodyState();
}

class _QRScannerBodyState extends State<QRScannerBody> {
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  Barcode? result;
  QRViewController? controller;

  @override
  void initState() {
    super.initState();
    final qrLoadingViewModel = Provider.of<QRLoadingViewModel>(context,listen: false);
    fetchUserIp(qrLoadingViewModel);
  }

  void fetchUserIp(QRLoadingViewModel viewModel) async {
    final companyDataViewModel = Provider.of<CompanyDataViewModel>(context,listen: false);

    viewModel.updateQRLoafing(true);
    await UserService().isConnectedToCompanyWiFi().then((value) {
      companyDataViewModel.updateIsCompany(value.startsWith(companyDataViewModel.ip));
      viewModel.updateQRLoafing(false);
    });
  }
  @override
  Widget build(BuildContext context) {
    final qrLoadingViewModel = Provider.of<QRLoadingViewModel>(context, listen: true);
    final companyDataViewModel = Provider.of<CompanyDataViewModel>(context, listen: true);
    return qrLoadingViewModel.isLoading
        ? Center(child: SpinKitCircle(color: Color.fromRGBO(236, 0, 60, 1), size: 30,))
        : companyDataViewModel.isCompany
        ? Stack(
      children: [
        // Camera preview
        QRView(key: qrKey, onQRViewCreated: _onQRViewCreated),

        // Dark overlay with a transparent cutout for scanning
        Positioned.fill(
          child: ClipPath(
            clipper: ScannerOverlay(),
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),
        ),

        // Scanning frame with corner indicators
        Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Center(
            child: Container(
              width: 300, // Adjust the width as needed
              height: 300, // Adjust the height as needed
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: CustomPaint(
                      size: const Size(30, 30),
                      painter: CornerPainter(
                        isTop: true,
                        isLeft: true,
                        Stroke: 5,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: CustomPaint(
                      size: const Size(30, 30),
                      painter: CornerPainter(
                        isTop: true,
                        isLeft: false,
                        Stroke: 5,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: CustomPaint(
                      size: const Size(30, 30),
                      painter: CornerPainter(
                        isTop: false,
                        isLeft: true,
                        Stroke: 10,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CustomPaint(
                      size: const Size(30, 30),
                      painter: CornerPainter(
                        isTop: false,
                        isLeft: false,
                        Stroke: 10,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    )
        : Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, color: Color.fromRGBO(236, 0, 60, 1), size: 80),
          const SizedBox(height: 20),
          Text(
            "Not connected to company Wi-Fi",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(236, 0, 60, 1),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            "Please connect to your office Wi-Fi to Scan QR and Mark Attendance.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () async {
              AppService().openWifiSettings();
            },
            icon: Icon(Icons.settings, color: Colors.white,),
            label: Text("Open Wi-Fi Settings", style: TextStyle(color: Colors.white),),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(236, 0, 60, 1),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          )
        ],
      ),
    )
    ;
  }



  void _onQRViewCreated(QRViewController controller) {
    final viewModel = Provider.of<CompanyDataViewModel>(context, listen: false);
    final navigationViewModel = Provider.of<NavigationViewModel>(context, listen: false);
    final UserService userService = UserService();
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {

      result = scanData;
      if(result!.code != null){
        String? data = result!.code;
        String decodedData = utf8.decode(base64Decode(data!));
        if(decodedData == viewModel.code) {
          controller.dispose();

          await userService.markAttendance().then((result){
            showLottieSuccessPopup(context, result['msg'], result['status']);
          });
          navigationViewModel.updateIndex(0);

        }
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

// Custom clipper to create a transparent QR scanning box in the middle
class ScannerOverlay extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double scanBoxSize = 300;
    double scanBoxX = (size.width - scanBoxSize) / 2;
    double scanBoxY = (size.height - scanBoxSize) / 2;

    Path path = Path();
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height)); // Full screen
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(scanBoxX, scanBoxY, scanBoxSize, scanBoxSize),
        Radius.circular(20),
      ),
    );
    path.fillType = PathFillType.evenOdd; // Makes the inside part transparent

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
