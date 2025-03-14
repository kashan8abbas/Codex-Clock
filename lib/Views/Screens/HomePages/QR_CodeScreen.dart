import 'package:codex_clock/Views/Screens/AuthScreens/TakePhotoScreen.dart';
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
    return Stack(
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
                      painter: CornerPainter(isTop: true, isLeft: true),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: CustomPaint(
                      size: const Size(30, 30),
                      painter: CornerPainter(isTop: true, isLeft: false),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: CustomPaint(
                      size: const Size(30, 30),
                      painter: CornerPainter(isTop: false, isLeft: true),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CustomPaint(
                      size: const Size(30, 30),
                      painter: CornerPainter(isTop: false, isLeft: false),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _cornerDecoration({
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border(
            top:
                top != null
                    ? BorderSide(color: Colors.red, width: 4)
                    : BorderSide.none,
            left:
                left != null
                    ? BorderSide(color: Colors.red, width: 4)
                    : BorderSide.none,
            right:
                right != null
                    ? BorderSide(color: Colors.red, width: 4)
                    : BorderSide.none,
            bottom:
                bottom != null
                    ? BorderSide(color: Colors.red, width: 4)
                    : BorderSide.none,
          ),
        ),
      ),
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
