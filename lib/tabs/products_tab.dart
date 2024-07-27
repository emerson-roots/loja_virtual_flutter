import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/categoria.dart';
import 'package:loja_virtual/interfaces/http_service.dart';
import 'package:loja_virtual/tiles/category_tile.dart';
import 'package:provider/provider.dart';

class ProductsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _httpService = Provider.of<IHttpService>(context);

    return FutureBuilder<List<Categoria>>(
        future: _httpService.getAllCategorias(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var dividedTiles = ListTile.divideTiles(
              tiles: snapshot.data!.map((doc) {
                return CategoryTileCustom(doc);
              }).toList(),
              color: Colors.grey[500],
            ).toList();

            return ListView(
              children: dividedTiles,
            );
          }
        });
  }
}
