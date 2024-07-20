import 'package:flutter/material.dart';
import 'package:loja_virtual/widgets/cart_button.dart';

import '../tabs/home_tab.dart';
import '../tabs/orders_tab.dart';
import '../tabs/places_tab.dart';
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
          body: const HomeTab(),
          drawer: CustomDrawer(_pageController),
          floatingActionButton: CartButtonCustomizado(true),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text("Produtos"),
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          drawer: CustomDrawer(_pageController),
          body: ProductsTab(),
          floatingActionButton: CartButtonCustomizado(true),
        ),
        Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: const Text(
              "Lojas",
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
          body: PlacesTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: const Text(
              "Meus Pedidos",
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
          body: OrdersTab(),
          drawer: CustomDrawer(_pageController),
        )
      ],
    );
  }
}
