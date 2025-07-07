import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserDataViewModel with ChangeNotifier {
  String _uid = '';
  String _firstName = '';
  String _lastName = '';
  String _cnic = '';
  String _email = '';
  String _phone = '';
  String _position = '';
  Map<String, dynamic> _dateOfBirth = {};
  String _gender = '';
  String _permanentAddress = '';
  String _currentAddress = '';
  Map<String, dynamic> _dateOfJoining = {};
  String _profilePic = '';
  Timestamp _createdAt = Timestamp(0, 0);
  String _status = '';

  String get uid => _uid;
  String get cnic => _cnic;
  String get currentAddress => _currentAddress;
  Map<String, dynamic> get dateOfBirth => _dateOfBirth;
  Map<String, dynamic> get dateOfJoining => _dateOfJoining;
  String get email => _email;
  String get firstName => _firstName;
  String get gender => _gender;
  String get lastName => _lastName;
  String get permanentAddress => _permanentAddress;
  String get phone => _phone;
  String get position => _position;
  String get profilePic => _profilePic;
  String get status => _status;
  Timestamp get createdAt => _createdAt;


  void updateUserData(
      String uid,
      String firstName,
      String lastName,
      String cnic,
      String phone,
      String email,
      String position,
      Map<String, dynamic> dateOfBirth,
      String gender,
      String permanentAddress,
      String currentAddress,
      Map<String, dynamic> dateOfJoining,
      String profilePic,
      Timestamp createdAt,
      String status) {
    _uid = uid;
    _cnic = cnic;
    _currentAddress = currentAddress;
    _dateOfBirth = dateOfBirth;
    _dateOfJoining = dateOfJoining;
    _email = email;
    _firstName = firstName;
    _gender = gender;
    _lastName = lastName;
    _permanentAddress = permanentAddress;
    _phone = phone;
    _position = position;
    _profilePic = profilePic;
    _createdAt = createdAt;
    _status = status;
    notifyListeners();
  }



  void clearData() {
    _uid = '';
    _cnic = '';
    _currentAddress = '';
    _dateOfBirth = {};
    _dateOfJoining = {};
    _email = '';
    _firstName = '';
    _gender = '';
    _lastName = '';
    _permanentAddress = '';
    _phone = '';
    _position = '';
    _profilePic = '';
    _createdAt = Timestamp(0, 0);
    _status = '';
    notifyListeners();
  }
}
