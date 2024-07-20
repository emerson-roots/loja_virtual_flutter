import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/cart_screen.dart';

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
      onPressed: () {
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
