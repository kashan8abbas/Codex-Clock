import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppService {

  Future<Map<String, dynamic>?> fetchCompanyCode() async {
    try {

      DocumentSnapshot<Map<String, dynamic>> companyDocument = await FirebaseFirestore.instance
          .collection('Company')
          .doc('secrete_code')
          .get();

      if (companyDocument.exists) {
        Map<String, dynamic> companyData = companyDocument.data() ?? {};

        return companyData;
      } else {
      }
    } catch (e) {
      throw Exception("Failed to fetch current user data");
    }
    return null;
  }

  Future<Map<String, dynamic>?> fetchCompanyWiFi() async {
    try {

      DocumentSnapshot<Map<String, dynamic>> companyDocument = await FirebaseFirestore.instance
          .collection('Company')
          .doc('wifi_address')
          .get();

      if (companyDocument.exists) {
        Map<String, dynamic> companyData = companyDocument.data() ?? {};

        return companyData;
      } else {
      }
    } catch (e) {
      throw Exception("Failed to fetch current user data");
    }
    return null;
  }

  Future<Map<String, dynamic>?> fetchCompanyTiming() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> companyDocument = await FirebaseFirestore.instance
          .collection('Company')
          .doc('timing')
          .get();

      if (companyDocument.exists) {
        Map<String, dynamic> companyData = companyDocument.data() ?? {};

        return companyData;
      } else {
      }
    } catch (e) {
      throw Exception("Failed to fetch current user data");
    }
    return null;
  }

  void openWifiSettings() {
    final intent = AndroidIntent(
      action: 'android.settings.WIFI_SETTINGS',
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    intent.launch();
  }
}