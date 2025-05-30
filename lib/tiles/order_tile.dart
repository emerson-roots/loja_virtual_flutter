import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:loja_virtual/datas/order.dart';
import 'package:loja_virtual/interfaces/http_service.dart';
import 'package:loja_virtual/widgets/custom_activity_indicator.dart';

class OrderTile extends StatelessWidget {
  final OrderModel orderObj;

  OrderTile(this.orderObj, {super.key});

  @override
  Widget build(BuildContext context) {
    int status = orderObj.status ?? 1;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Código do pedido: ${orderObj.id}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 4.0,
            ),
            Text(_buildProductsText(orderObj)),
            const SizedBox(
              height: 4.0,
            ),
            const Text(
              "Status do Pedido:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 4.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildCircle("1", "Preparação", status, 1),
                Container(
                  height: 1.0,
                  width: 40.0,
                  color: Colors.grey.shade500,
                ),
                _buildCircle("2", "Transporte", status, 2),
                Container(
                  height: 1.0,
                  width: 40.0,
                  color: Colors.grey.shade500,
                ),
                _buildCircle("3", "Entrega", status, 3),
              ],
            )
          ],
        ),
      ),
    );
  }

  String _buildProductsText(OrderModel obj) {
    String text = "Descrição:\n";
    for (var p in obj.products) {
      text +=
          "${p.quantity} x ${p.product.title} (R\$ ${p.product.price!.toStringAsFixed(2)})\n";
    }

    text += "Total: R\$ ${obj.totalPrice.toStringAsFixed(2)}";
    return text;
  }

  Widget _buildCircle(
      String title, String subtitle, int status, int thisStatus) {
    Color backColor;
    Widget child;

    if (status < thisStatus) {
      backColor = Colors.grey.shade500;
      child = Text(
        title,
        style: const TextStyle(color: Colors.white),
      );
    } else if (status == thisStatus) {
      backColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    } else {
      backColor = Colors.green;
      child = const Icon(
        Icons.check,
        color: Colors.white,
      );
    }

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subtitle)
      ],
    );
  }
}
