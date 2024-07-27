import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/categoria.dart';

import '../datas/product_data.dart';
import '../tiles/product_tile.dart';

class CategoryScreen extends StatelessWidget {
  final Categoria categoria;

  CategoryScreen(this.categoria);

  int qtdTabs = 2;
  int maximoItensNaHorizontal = 2;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: qtdTabs,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            categoria.title,
            style: const TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  Icons.grid_on,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.list,
                ),
              )
            ],
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('products')
              .doc(categoria.id)
              .collection('items')
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              int qtdItensNaGrade = snapshot.data!.docs.length;

              return TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  GridView.builder(
                    padding: const EdgeInsets.all(4.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: maximoItensNaHorizontal,
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: qtdItensNaGrade,
                    itemBuilder: (context, index) {
                      ProductData data =
                          ProductData.fromDocument(snapshot.data!.docs[index]);
                      data.category = this.categoria.id;
                      return ProductTile(
                        "grid",
                        data,
                      );
                    },
                  ),
                  ListView.builder(
                      padding: const EdgeInsets.all(4.0),
                      itemCount: qtdItensNaGrade,
                      itemBuilder: (context, index) {
                        ProductData data = ProductData.fromDocument(
                            snapshot.data!.docs[index]);
                        data.category = this.categoria.id;
                        return ProductTile(
                          "list",
                          data,
                        );
                      })
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
