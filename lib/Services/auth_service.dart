import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codex_clock/Utils/Utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> verifyPhoneNumber(String phoneNumber) async {
    final Completer<String> completer = Completer();

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
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

      await auth.signInWithCredential(credential);
      return {
        'credentials': credential,
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
    required String verificationId,
    required String smsCode,
    required PhoneAuthCredential phoneCredential,
    required String firstName,
    required String lastName,
    required String cnic,
    required String email,
    required String phone,
    required String password,
    required String position,
    required Map<String, dynamic> dateOfBirth,
    required String gender,
    required String permanentAddress,
    required String currentAddress,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {

      UserCredential phoneUser = await auth.signInWithCredential(phoneCredential);
      User? user = phoneUser.user;

      // Step 2: Link email/password to the phone-authenticated user
      AuthCredential emailCredential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      await user!.linkWithCredential(emailCredential);

      String uid = user.uid;

      // Step 3: Store user data in Firestore
      await firestore.collection("Users").doc(uid).set({
        'Uid': uid,
        'firstName': firstName,
        'lastName': lastName,
        'cnic': cnic,
        'email': email,
        'phone': phone,
        'position': position,
        'dateOfBirth': dateOfBirth,
        'gender': gender,
        'permanentAddress': permanentAddress,
        'currentAddress': currentAddress,
        'createdAt': FieldValue.serverTimestamp(),
      });


    } catch (e) {
      print("Sign up failed: $e");
      rethrow;
    }
  }




}

