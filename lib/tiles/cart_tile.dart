import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/helpers/console_helper.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/services/check_internet_service.dart';
import 'package:loja_virtual/widgets/message_helper.dart';

class CartTile extends StatelessWidget {
  final CartProduct cartProduct;

  CartTile(this.cartProduct);

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

    Widget buildContent() {
      /// 29/05/2025 - comentado pois estava sendo chamado em LOOP;
      // CartModel.of(context).updatePrices();
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(
              8.0,
            ),
            width: 115.0,
            height: 140.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: Image.network(
                cartProduct.productData!.images![0],
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    cartProduct.productData!.title!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 17.0),
                  ),
                  Text(
                    "Tamanho: ${cartProduct.size}",
                    style: const TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Text(
                    "R\$ ${cartProduct.productData!.price!.toStringAsFixed(2)}",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: cartProduct.quantity! > 1
                            ? () async {
                                if (!await CheckInternetService
                                    .hasInternetConnection()) {
                                  MessageHelper.showSnackBarMessage(
                                      context: context,
                                      mensagem:
                                          'Sem internet ou conexão limitada.',
                                      corSnackBar: Colors.redAccent,
                                      tempoDuracaoMensagem: 4);
                                  return;
                                }

                                await CartModel.of(context)
                                    .decrementProduct(cartProduct);
                              }
                            : null,
                        icon: const Icon(Icons.remove),
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(cartProduct.quantity.toString()),
                      IconButton(
                          onPressed: () async {
                            try {
                              if (!await CheckInternetService
                                  .hasInternetConnection()) {
                                MessageHelper.showSnackBarMessage(
                                    context: context,
                                    mensagem:
                                        'Sem internet ou conexão limitada.',
                                    corSnackBar: Colors.redAccent,
                                    tempoDuracaoMensagem: 4);
                                return;
                              }

                              await CartModel.of(context)
                                  .incrementProduct(cartProduct);
                            } catch (ex, stack) {
                              ConsoleHelper.printError(
                                  'Erro: $ex | Stack: $stack');
                              _showSnackBarMessage(
                                  mensagem: ex.toString(),
                                  corSnackBar: Colors.redAccent,
                                  tempoDuracaoMensagem: 4);
                            }
                          },
                          icon: const Icon(Icons.add),
                          color: Theme.of(context).primaryColor),
                      TextButton(
                          onPressed: () async {
                            try {
                              if (!await CheckInternetService
                                  .hasInternetConnection()) {
                                MessageHelper.showSnackBarMessage(
                                    context: context,
                                    mensagem:
                                        'Sem internet ou conexão limitada.',
                                    corSnackBar: Colors.redAccent,
                                    tempoDuracaoMensagem: 4);
                                return;
                              }
                              await CartModel.of(context)
                                  .removeCartItem(cartProduct);
                            } catch (ex, stack) {
                              ConsoleHelper.printError(
                                  'Erro: $ex | Stack: $stack');
                              _showSnackBarMessage(
                                  mensagem: ex.toString(),
                                  corSnackBar: Colors.redAccent,
                                  tempoDuracaoMensagem: 4);
                            }
                          },
                          child: const Text(
                            "Remover",
                            style: TextStyle(color: Colors.grey),
                          ))
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: buildContent(),
    );
  }
}
