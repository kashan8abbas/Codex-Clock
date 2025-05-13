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
}