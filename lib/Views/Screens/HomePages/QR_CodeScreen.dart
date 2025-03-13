import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

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
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: QRView(key: qrKey, onQRViewCreated: _onQRViewCreated),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child:
                (result != null)
                    ? Text("Barcode Data: ${result!.code}")
                    : const Text("Scan a Code"),
          ),
        ),
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
