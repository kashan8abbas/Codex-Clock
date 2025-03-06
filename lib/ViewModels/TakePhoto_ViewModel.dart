import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraViewModel extends ChangeNotifier {
  CameraController? _cameraController;
  List<File> _recentImages = [];
  bool _isCameraInitialized = false;

  CameraController? get cameraController => _cameraController;
  List<File> get recentImages => _recentImages;
  bool get isCameraInitialized => _isCameraInitialized;

  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _cameraController = CameraController(
          cameras[0],
          ResolutionPreset.medium,
        );
        await _cameraController!.initialize();
        _isCameraInitialized = true;
        notifyListeners();
      } else {
        debugPrint("No cameras available");
      }
    } catch (e) {
      debugPrint("Error initializing camera: $e");
    }
  }

  Future<void> capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      debugPrint("Camera not initialized");
      return;
    }
    try {
      final XFile photo = await _cameraController!.takePicture();
      _recentImages.add(File(photo.path));
      notifyListeners();
    } catch (e) {
      debugPrint("Error capturing photo: $e");
    }
  }

  Future<void> pickFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      _recentImages.add(File(pickedFile.path));
      notifyListeners();
    }
  }

  Future<void> switchCamera() async {
    if (_cameraController == null) return;
    final cameras = await availableCameras();
    int newCameraIndex =
        cameras.indexOf(_cameraController!.description) == 0 ? 1 : 0;

    _cameraController = CameraController(
      cameras[newCameraIndex],
      ResolutionPreset.medium,
    );
    await _cameraController!.initialize();
    notifyListeners();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}
