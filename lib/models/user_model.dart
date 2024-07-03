import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;
  UserCredential? firebaseUser;
  Map<String, dynamic> userData = Map();

  bool isLoading = false;

  bool signUp({required Map<String, dynamic> userData,
    required String pass,
    required VoidCallback onSuccess,
    required VoidCallback onFail}) {
    configuraIsLoading(true);

    bool isContaCriadaComSucesso = false;
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
      isContaCriadaComSucesso = true;
    }).catchError((ex) {
      onFail();
      configuraIsLoading(false);
      isContaCriadaComSucesso = false;
    });
    return isContaCriadaComSucesso;
  }

  void signIn() async {
    configuraIsLoading(true);
    await Future.delayed(const Duration(seconds: 3));
    configuraIsLoading(false);
  }

  void recoverPass() {
  }

  bool isLoggedIn() {
    return firebaseUser != null;
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

  void signOut() async {
    await _auth.signOut();

    userData = Map();
    firebaseUser = null;

    notifyListeners();
  }
}
