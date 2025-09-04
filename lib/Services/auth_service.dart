import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codex_clock/Utils/Utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthService {

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> verifyPhoneNumber(String phoneNumber) async {
    final Completer<String> completer = Completer();

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 120),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        print('User signed in automatically');
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Verification failed: ${e.message}');
        completer.completeError(e); // Pass the error back
      },
      codeSent: (String verificationId, int? resendToken) {
        print('Code sent. Save verificationId: $verificationId');
        completer.complete(verificationId); // Return the ID
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('Auto retrieval timeout');
      },
    );

    return completer.future;
  }

  Future<Map<String, dynamic>> signInWithOTP(String smsCode, String verificationId) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      UserCredential phoneUser = await auth.signInWithCredential(credential);
      User? user = phoneUser.user;


      String uid = user!.uid;

      return {
        'uid': uid,
        'status': 'success'
      };
    }
    on FirebaseAuthException catch (e) {
      return {
        'error': e.message.toString(),
        'status': 'failed',
      };
    }
  }

  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      Utilities().getMessageFromErrorCode(e.code);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
    return null;
  }

  Future<void> signUpService({
    required String firstName,
    required String lastName,
    required String cnic,
    required String phone,
    required String email,
    required String password,
    required String position,
    required Map<String, dynamic> dateOfBirth,
    required String gender,
    required String permanentAddress,
    required String currentAddress,
    required Map<String, dynamic> dateOfJoining,
    required File imageFile,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final String uid = userCredential.user!.uid;

      final String? imageUrl = await uploadImageToFirebase(imageFile);

      await FirebaseFirestore.instance.collection('Users').doc(uid).set({
        'Uid': uid,
        'firstName': firstName,
        'lastName': lastName,
        'cnic': cnic,
        'phone': phone,
        'email': email,
        'position': position,
        'dateOfBirth': dateOfBirth,
        'gender': gender,
        'permanentAddress': permanentAddress,
        'currentAddress': currentAddress,
        'dateOfJoining': dateOfJoining,
        'profilePic': imageUrl ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending'
      });
    } catch (e) {
      // Handle errors appropriately
      print('Error during signup: $e');
      rethrow;
    }
  }


  Future<String?> uploadImageToFirebase(File imageFile) async {
    try {

      final storageRef = FirebaseStorage.instance.ref();
      final imageRef = storageRef.child("images/${DateTime.now().millisecondsSinceEpoch}.jpg");

      // Upload the image
      await imageRef.putFile(imageFile);

      // Get the download URL
      final downloadUrl = await imageRef.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      Utilities().errorMsg('Error uploading image, Please try again');
      return null;
    }
  }

}

