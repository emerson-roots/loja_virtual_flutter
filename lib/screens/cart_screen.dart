import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/cart_model.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text(
          "Meu Carrinho",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 8.0),
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model) {
                int qtdProdutos = model.products.length;
                String textoPlural = qtdProdutos == 1 ? "ITEM" : "ITENS";
                return Text(
                  "${qtdProdutos} ${textoPlural}",
                  style: const TextStyle(color: Colors.white, fontSize: 17.0),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
