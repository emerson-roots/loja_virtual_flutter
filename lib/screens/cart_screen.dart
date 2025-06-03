import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/screens/order_screen.dart';
import 'package:loja_virtual/tiles/discount_card.dart';
import 'package:loja_virtual/widgets/cart_price.dart';
import 'package:loja_virtual/widgets/message_helper.dart';
import 'package:loja_virtual/widgets/ship_card.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/cart_model.dart';
import '../tiles/cart_tile.dart';
import '../widgets/custom_activity_indicator.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late bool isAbriuCarrinho = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isAbriuCarrinho) {
        MessageHelper.showSnackBarMessage(
            context: context,
            mensagem:
                'Utilize os cupons, 10OFF e 20OFF para simular o uso de cupons.\n\nCalculo de frente ainda não está implementado.',
            corSnackBar: Colors.deepOrange,
            tempoDuracaoMensagem: 5);

        isAbriuCarrinho = true;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // isAbriuCarrinho = false;
    super.dispose();
  }

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
            padding: const EdgeInsets.only(right: 8.0),
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
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, model) {
          if (model.isLoading && UserModel.of(context).isLoggedIn()) {
            return CustomActivityIndicator();
          } else if (!UserModel.of(context).isLoggedIn()) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.remove_shopping_cart,
                    size: 80.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    "Faça o login para adicionar produtos!",
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
          } else if (model.products == null || model.products.isEmpty) {
            return const Center(
              child: Text(
                "Nenhum produto no carrinho!",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView(
              children: [
                Column(
                  children: model.products.map((produto) {
                    return CartTile(produto);
                  }).toList(),
                ),
                DiscountCard(),
                ShipCard(),
                CartPrice(() async {
                  var orderId = await model.finishOrder();
                  if (!orderId!.isEmpty) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => OrderScreen(orderId)));
                  }
                })
              ],
            );
          }
        },
      ),
    );
  }
}
