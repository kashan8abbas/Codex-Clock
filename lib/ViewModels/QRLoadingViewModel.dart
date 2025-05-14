import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QRLoadingViewModel with ChangeNotifier {
  bool _loading = true;

  bool get isLoading => _loading;

  void updateQRLoafing(
      bool value) {
    _loading = value;
    notifyListeners();
  }
}
