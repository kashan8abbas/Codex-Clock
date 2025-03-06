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
      appBar: AppBar(
        title: const Text("Take Photo"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<CameraViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              // Camera Preview
              Expanded(
                child:
                    viewModel.isCameraInitialized
                        ? CameraPreview(viewModel.cameraController!)
                        : const Center(child: CircularProgressIndicator()),
              ),

              // Capture and controls
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
