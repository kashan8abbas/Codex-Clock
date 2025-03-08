import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:codex_clock/ViewModels/TakePhoto_ViewModel.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CameraViewModel>(context, listen: false).initializeCamera();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 245, 248, 1),
      body: Consumer<CameraViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              // Camera Preview
              Expanded(
                child: Stack(
                  children: [
                    // Camera Preview (Full-Screen)
                    Positioned.fill(
                      child:
                          viewModel.isCameraInitialized
                              ? CameraPreview(viewModel.cameraController!)
                              : const Center(
                                child: CircularProgressIndicator(),
                              ),
                    ),

                    // "Take Photo" Title at the Top
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(236, 0, 60, 1),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center, // Centers the row content
                            children: [
                              // Back Button (Trailing Button)
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_sharp,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),

                              // Spacer to push the title to center
                              const Expanded(
                                child: Center(
                                  child: Text(
                                    "Take Photo",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),

                              // Invisible button to maintain balance (optional)
                              const SizedBox(width: 48),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Scan Box at the Center
                    Padding(
                      padding: const EdgeInsets.only(top: 48.0),
                      child: Center(
                        child: Container(
                          width: 300, // Adjust the width as needed
                          height: 320, // Adjust the height as needed
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
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Capture and controls
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.image, size: 32),
                      onPressed: () => viewModel.pickFromGallery(),
                    ),
                    const SizedBox(width: 40),
                    GestureDetector(
                      onTap: () => viewModel.capturePhoto(),
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(246, 245, 248, 1),
                          shape: BoxShape.circle,
                          border: Border.all(width: 4, color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                    IconButton(
                      icon: const Icon(Icons.flip_camera_ios, size: 32),
                      onPressed: () => viewModel.switchCamera(),
                    ),
                  ],
                ),
              ),

              // Thumbnails of recent images
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: viewModel.recentImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          viewModel.recentImages[index],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CornerPainter extends CustomPainter {
  final bool isTop;
  final bool isLeft;
  final double radius; // Radius for rounded corners

  CornerPainter({
    required this.isTop,
    required this.isLeft,
    this.radius = 20.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color.fromRGBO(246, 245, 248, 1)
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke;

    final path = Path();

    if (isTop && isLeft) {
      path.moveTo(0, 50);
      path.lineTo(0, radius);
      path.quadraticBezierTo(0, 0, radius, 0);
      path.lineTo(50, 0);
    } else if (isTop && !isLeft) {
      path.moveTo(size.width - 50, 0);
      path.lineTo(size.width - radius, 0);
      path.quadraticBezierTo(size.width, 0, size.width, radius);
      path.lineTo(size.width, 50);
    } else if (!isTop && isLeft) {
      path.moveTo(0, size.height - 50);
      path.lineTo(0, size.height - radius);
      path.quadraticBezierTo(0, size.height, radius, size.height);
      path.lineTo(50, size.height);
    } else {
      path.moveTo(size.width - 50, size.height);
      path.lineTo(size.width - radius, size.height);
      path.quadraticBezierTo(
        size.width,
        size.height,
        size.width,
        size.height - radius,
      );
      path.lineTo(size.width, size.height - 50);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
