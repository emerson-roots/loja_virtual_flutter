import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/widgets/custom_activity_indicator.dart';

import '../models/user_model.dart';
import '../screens/login_screen.dart';
import '../tiles/order_tile.dart';

class OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn()) {
      String uid = UserModel.of(context).firebaseUser!.uid!;
      var pedidosUsuario = FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("orders")
          .get();

      return FutureBuilder<QuerySnapshot>(
          future: pedidosUsuario,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CustomActivityIndicator();
            } else {
              return ListView(
                children: snapshot.data!.docs
                    .map((doc) => OrderTile(doc.id))
                    .toList(),
              );
            }
          });
    } else {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.view_list,
              size: 80.0,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 16.0),
            const Text(
              "Faça o login para acompanhar!",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                disabledBackgroundColor: Colors.grey.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: const Text(
                "Entrar",
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            )
          ],
        ),
      );
    }
  }
}
