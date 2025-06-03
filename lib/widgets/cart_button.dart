import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/cart_screen.dart';
import 'package:loja_virtual/services/check_internet_service.dart';
import 'package:loja_virtual/widgets/message_helper.dart';

class CartButtonCustomizado extends StatelessWidget {
  bool isBotaoArredondado = false;

  CartButtonCustomizado(this.isBotaoArredondado);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: isBotaoArredondado
          ? const StadiumBorder()
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3.0),
            ),
      onPressed: () async {
        if (!await CheckInternetService.hasInternetConnection()) {
          MessageHelper.showSnackBarMessage(
              context: context,
              mensagem: 'Sem conexão com internet ou conexão limitada',
              corSnackBar: Colors.redAccent,
              tempoDuracaoMensagem: 4);
          return;
        }
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CartScreen()));
      },
      backgroundColor: Theme.of(context).primaryColor,
      child: const Icon(
        Icons.shopping_cart,
        color: Colors.white,
      ),
    );
  }
}
