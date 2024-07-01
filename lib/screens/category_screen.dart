import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  final DocumentSnapshot snapshot;

  CategoryScreen(this.snapshot);

  int qtdTabs = 2;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: qtdTabs,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            snapshot.get('title'),
          ),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.grid_on),
              ),
              Tab(
                icon: Icon(Icons.list),
              )
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Container(
              color: Colors.red,
            ),
            Container(
              color: Colors.blue,
            )
          ],

        ),
      ),
    );
  }
}
