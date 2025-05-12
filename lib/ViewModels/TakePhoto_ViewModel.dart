import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraViewModel extends ChangeNotifier {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  File? _selectedImage;

  CameraController? get cameraController => _cameraController;
  bool get isCameraInitialized => _isCameraInitialized;
  File? get selectedImage => _selectedImage;

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

  Future<void> capturePhoto(BuildContext context) async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      debugPrint("Camera not initialized");
      return;
    }
    try {
      final XFile photo = await _cameraController!.takePicture();
      _selectedImage = File(photo.path);
      notifyListeners();
      disposeCamera();
      Navigator.pop(context);
    } catch (e) {
      debugPrint("Error capturing photo: $e");
    }
  }

  Future<void> pickFromGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      disposeCamera();
      Navigator.pop(context);
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

  void disposeCamera() {
    _cameraController?.dispose();
    _cameraController = null;
    _isCameraInitialized = false;
    notifyListeners();
  }
}
