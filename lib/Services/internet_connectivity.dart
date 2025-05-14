import 'package:codex_clock/Services/user_service.dart';
import 'package:codex_clock/ViewModels/QRLoadingViewModel.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

import 'package:provider/provider.dart';

import '../ViewModels/CompanyData_ViewModel.dart';

class ConnectivityHelper {
  static final Connectivity _connectivity = Connectivity();
  static late StreamSubscription<List<ConnectivityResult>> _subscription;
  static bool _isDialogVisible = false;

  /// Call this method in the `initState` of any page to listen for connectivity changes.
  static void listenToConnectivityChanges(BuildContext context) {
    _subscription = _connectivity.onConnectivityChanged.listen((result) async {

      if (result.contains(ConnectivityResult.none)) {
        _showInternetStatusDialog(context, "No Internet Connection");
      } else {
        if (_isDialogVisible) {
          Navigator.of(context).pop(); // Automatically close the dialog
          _isDialogVisible = false;
          _showInternetStatusDialog(context, "Internet Connected");
        }
        final qrLoadingViewModel = Provider.of<QRLoadingViewModel>(context, listen: false);
        final companyDataViewModel = Provider.of<CompanyDataViewModel>(context,listen: false);

        qrLoadingViewModel.updateQRLoafing(true);
        await UserService().isConnectedToCompanyWiFi().then((value) {
          companyDataViewModel.updateIsCompany(value.startsWith(companyDataViewModel.ip));
          qrLoadingViewModel.updateQRLoafing(false);
        });


      }
    });
  }

  /// Method to display a connectivity status dialog.
  static void _showInternetStatusDialog(BuildContext context, String message) {
    if (!_isDialogVisible) {
      _isDialogVisible = true;
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dismissal by tapping outside
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                message.contains("No")
                    ? Icons.wifi_off_rounded
                    : Icons.wifi_rounded,
                size: 50,
                color: message.contains("No") ? Color.fromRGBO(236, 0, 60, 1) : Colors.green,
              ),
              const SizedBox(height: 16),
              Text(
                message.contains("No") ? "Connection Lost" : "Connected",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: message.contains("No") ? Color.fromRGBO(236, 0, 60, 1) : Colors.green,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            if (!message.contains("No"))
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _isDialogVisible = false;
                  },
                  icon: Icon(Icons.check_circle_rounded, color: Colors.white),
                  label: Text(
                    "OK",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }
  }

  /// Call this method in the `dispose` of the page to stop listening.
  static void disposeConnectivityListener() {
    _subscription.cancel();
  }
}
