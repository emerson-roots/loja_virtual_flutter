import 'package:flutter/material.dart';

import '../tabs/home_tab.dart';
import '../tabs/products_tab.dart';
import '../widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  // controladores
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Produtos"),
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          drawer: CustomDrawer(_pageController),
          body: ProductsTab(),
        ),
        Container(
          color: Colors.yellow,
        ),
        Container(
          color: Colors.pink,
        )
      ],
    );
  }
}
