import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';

class ShipCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    void _showSnackBarMessage({
      required String mensagem,
      required Color corSnackBar,
      required int tempoDuracaoMensagem,
    }) {
      var snackBar = SnackBar(
        content: Text(mensagem),
        backgroundColor: corSnackBar,
        duration: Duration(seconds: tempoDuracaoMensagem),
        action: SnackBarAction(
          label: 'FECHAR',
          textColor: Colors.white,
          onPressed: () {
            // Alguma ação opcional
          },
        ),
      );

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          "Calcular Frete",
          textAlign: TextAlign.start,
          style: TextStyle(
              fontWeight: FontWeight.w500, color: Colors.grey.shade700),
        ),
        leading: const Icon(Icons.location_on_outlined),
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "Digite seu CEP"),
              initialValue: "",
              onFieldSubmitted: (text) {

              },
            ),
          ),
        ],
      ),
    );
  }
}
