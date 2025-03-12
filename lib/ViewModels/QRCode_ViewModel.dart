import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerViewModel extends ChangeNotifier {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String qrText = "";

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      qrText = scanData.code ?? "";
      notifyListeners();
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
