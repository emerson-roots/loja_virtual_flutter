import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/categoria.dart';
import 'package:loja_virtual/screens/category_screen.dart';

class CategoryTileCustom extends StatelessWidget {
  /*
  * properties */
  final Categoria categoria;

  CategoryTileCustom(this.categoria);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(categoria.icon),
      ),
      title: Text(
        categoria.title,
      ),
      trailing: const Icon(Icons.keyboard_arrow_right),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => CategoryScreen(categoria))
        );
      },
    );
  }
}
