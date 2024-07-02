import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../datas/product_data.dart';
import '../tiles/product_tile.dart';

class CategoryScreen extends StatelessWidget {
  final DocumentSnapshot snapshot;

  CategoryScreen(this.snapshot);

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
            snapshot.get('title'),
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
              .doc(snapshot.id)
              .collection('items')
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              print('===========> passou aqui');
              int qtdItensNaGrade = snapshot.data!.docs.length;

              return TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  GridView.builder(
                    padding: EdgeInsets.all(4.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: maximoItensNaHorizontal,
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                        childAspectRatio: 0.65),
                    itemCount: qtdItensNaGrade,
                    itemBuilder: (context, index) {
                      return ProductTile(
                        "grid",
                        ProductData.fromDocument(snapshot.data!.docs[index]),
                      );
                    },
                  ),
                  ListView.builder(
                      padding: EdgeInsets.all(4.0),
                      itemCount: qtdItensNaGrade,
                      itemBuilder: (context, index) {
                        return ProductTile(
                          "list",
                          ProductData.fromDocument(
                            snapshot.data!.docs[index],
                          ),
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
