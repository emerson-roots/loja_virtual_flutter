import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/product_data.dart';

class ProductTile extends StatelessWidget {
  final String type;
  final ProductData product;

  ProductTile(this.type, this.product);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        child: type == "grid" ? _tabTipoColuna(context) : Row(),
      ),
    );
  }

  Column _tabTipoColuna(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 0.8,
          child: Image.network(
            product.images![0],
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
            child: Container(
          padding: EdgeInsets.all(6.0),
          child: Column(
            children: [
              Text(
                product.title!,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                "R\$ ${product.price!.toStringAsFixed(2)}",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ))
      ],
    );
  }
}
