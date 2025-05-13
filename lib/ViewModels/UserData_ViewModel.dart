import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserDataViewModel with ChangeNotifier {
  String _uid = '';
  String _cnic = '';
  String _currentAddress = '';
  Map<String, dynamic> _dateOfBirth = {};
  String _email = '';
  String _firstName = '';
  String _gender = '';
  String _lastName = '';
  String _permanentAddress = '';
  String _phone = '';
  String _position = '';
  String _profilePic = '';
  Timestamp _createdAt = Timestamp(0, 0);

  String get uid => _uid;
  String get cnic => _cnic;
  String get currentAddress => _currentAddress;
  Map<String, dynamic> get dateOfBirth => _dateOfBirth;
  String get email => _email;
  String get firstName => _firstName;
  String get gender => _gender;
  String get lastName => _lastName;
  String get permanentAddress => _permanentAddress;
  String get phone => _phone;
  String get position => _position;
  String get profilePic => _profilePic;
  Timestamp get createdAt => _createdAt;


  void updateUserData(
      String uid,
      String cnic,
      String currentAddress,
      Map<String, dynamic> dateOfBirth,
      String email,
      String firstName,
      String gender,
      String lastName,
      String permanentAddress,
      String phone,
      String position,
      String profilePic,
      Timestamp createdAt) {
    _uid = uid;
    _cnic = cnic;
    _currentAddress = currentAddress;
    _dateOfBirth = dateOfBirth;
    _email = email;
    _firstName = firstName;
    _gender = gender;
    _lastName = lastName;
    _permanentAddress = permanentAddress;
    _phone = phone;
    _position = position;
    _profilePic = profilePic;
    _createdAt = createdAt;
    notifyListeners();
  }



  void clearData() {
    _uid = '';
    _cnic = '';
    _currentAddress = '';
    _dateOfBirth = {};
    _email = '';
    _firstName = '';
    _gender = '';
    _lastName = '';
    _permanentAddress = '';
    _phone = '';
    _position = '';
    _profilePic = '';
    _createdAt = Timestamp(0, 0);
    notifyListeners();
  }
}
