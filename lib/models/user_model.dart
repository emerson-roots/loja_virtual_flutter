import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;
  UserCredential? firebaseUser;
  Map<String, dynamic> userData = Map();

  bool isLoading = false;

  void signUp({required Map<String, dynamic> userData,
    required String pass,
    required VoidCallback onSuccess,
    required VoidCallback onFail}) {
    configuraIsLoading(true);
    _auth
        .createUserWithEmailAndPassword(
      email: userData["email"],
      password: pass,
    )
        .then((user) async {
      firebaseUser = user;
      await _saveUserData(userData);

      onSuccess();
      configuraIsLoading(false);
    }).catchError((ex) {
      onFail();
      configuraIsLoading(false);
    });
  }

  void signIn() async {
    configuraIsLoading(true);
    await Future.delayed(const Duration(seconds: 3));
    configuraIsLoading(false);
  }

  void recoverPass() {
  }

  bool isLoggedIn() {
    return false;
  }

  void configuraIsLoading(bool isLoading) {
    isLoading = isLoading;
    notifyListeners();
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await FirebaseFirestore.instance.collection("users").doc(
        firebaseUser!.user!.uid).set(userData);
  }
}
