import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';

// Definindo o tipo de função que retorna uma String
typedef StringCallback = String Function(String);

class UserModel extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? firebaseUser;
  Map<String, dynamic> userData = Map();

  bool isLoading = false;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    _loadCurrentUser();
  }

  bool signUp(
      {required Map<String, dynamic> userData,
      required String pass,
      required VoidCallback onSuccess,
      required StringCallback onFail}) {
    configuraIsLoading(true);

    bool isContaCriadaComSucesso = false;
    _auth
        .createUserWithEmailAndPassword(
      email: userData["email"],
      password: pass,
    )
        .then((user) async {
      firebaseUser = user.user;
      await _saveUserData(userData);

      onSuccess();
      configuraIsLoading(false);
      isContaCriadaComSucesso = true;
    }).catchError((ex) {
      print("===============>>> Erro: " + ex.toString());
      onFail(ex.message);
      configuraIsLoading(false);
      isContaCriadaComSucesso = false;
    });
    return isContaCriadaComSucesso;
  }

  void signIn(
      {required String email,
      required String pass,
      required VoidCallback onSuccess,
      required StringCallback onFail}) async {
    configuraIsLoading(true);
    await _auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((user) async {
      print(user.toString());
      firebaseUser = user.user;
      await _loadCurrentUser();

      onSuccess();
      configuraIsLoading(false);
    }).catchError((ex) {
      print("===============>>> Erro: " + ex.toString());
      onFail(ex.message);
      configuraIsLoading(false);
    });
  }

  void recoverPass() {}

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  void configuraIsLoading(bool isLoading) {
    isLoading = isLoading;
    notifyListeners();
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser!.uid)
        .set(userData);
  }

  void signOut() async {
    await _auth.signOut();

    userData = Map();
    firebaseUser = null;

    notifyListeners();
  }

  Future<void> _loadCurrentUser() async {
    if (firebaseUser == null) firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      if (userData["name"] == null) {
        DocumentSnapshot docUser = await FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser!.uid)
            .get();

        userData = docUser.data() as Map<String, dynamic>? ?? {};
      }
    }

    notifyListeners();
  }
}
