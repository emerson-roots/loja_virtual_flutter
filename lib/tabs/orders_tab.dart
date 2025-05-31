import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:loja_virtual/datas/constantes_globais.dart';
import 'package:loja_virtual/datas/order.dart';
import 'package:loja_virtual/interfaces/http_service.dart';
import 'package:loja_virtual/widgets/custom_activity_indicator.dart';

import '../models/user_model.dart';
import '../screens/login_screen.dart';
import '../tiles/order_tile.dart';

class OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn()) {
      String uid = UserModel.of(context).usuarioObj!.id!;
      Future<List<OrderModel>> pedidosUsuario =
          GetIt.instance<IHttpService>(instanceName: ConstantesGlobais.FIREBASE_INJECTION).getPedidosByUserId(uid);

      return FutureBuilder<List<OrderModel>>(
          future: pedidosUsuario,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CustomActivityIndicator();
            } else {
              if (snapshot.data == null || snapshot.data!.isEmpty) {
                return Center(
                  child: Text('Você não possui pedidos finalizados.'),
                );
              } else {
                return ListView(
                  children: snapshot.data!
                      .map((doc) => OrderTile(doc))
                      .toList()
                      .reversed
                      .toList(),
                );
              }
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LoginScreen()));
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
