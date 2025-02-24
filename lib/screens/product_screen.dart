import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/cart_screen.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import '../datas/product_data.dart';

class ProductScreen extends StatefulWidget {
  final ProductData product;

  ProductScreen(this.product);

  @override
  State<ProductScreen> createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductData product;
  int _current = 0;
  String? sizeSelecionado;
  final CarouselController _controller = CarouselController();

  _ProductScreenState(this.product);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          product.title!,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _corpoDaTelaScrollable(),
    );
  }

  Widget _corpoDaTelaScrollable() {
    final Color primaryColor = Theme.of(context).primaryColor;
    const bool botaoArredondado = false;
    return ListView(
      children: [
        _carouselSlider(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // titulo
              Text(
                product.title!,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 3,
              ),
              // preço
              Text(
                "R\$ ${product.price!.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                "Tamanho",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
              // lista de tamanhos do produto
              SizedBox(
                height: 34.0,
                child: GridView(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.5),
                  children: product.sizes!.map((tamanhoProduto) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          sizeSelecionado = tamanhoProduto;
                        });
                      },
                      child: Container(
                        width: 50.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4.0)),
                          border: Border.all(
                            color: tamanhoProduto == sizeSelecionado
                                ? primaryColor
                                : Colors.grey.shade500,
                            width: 2.0,
                          ),
                        ),
                        child: Text(tamanhoProduto),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                height: 44.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    disabledBackgroundColor: Colors.grey.shade400,
                    shape: botaoArredondado
                        ? const StadiumBorder()
                        : RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                  ),
                  onPressed: sizeSelecionado != null ?
                      () {
                        if (UserModel.of(context).isLoggedIn()) {
                          CartProduct cartProduct = CartProduct();

                          cartProduct.size = sizeSelecionado;
                          cartProduct.quantity = 1;
                          cartProduct.pid = product.id;
                          cartProduct.category = product.category;
                          cartProduct.productData = product;

                          // adicionar ao carrinho
                          CartModel.of(context).addCartItem(cartProduct);

                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => CartScreen())
                          );
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => LoginScreen())
                          );
                        }
                      }
                      : null,
                  child: Text(UserModel.of(context).isLoggedIn() ?
                    "Adicionar ao Carrinho" : "Entre para comprar",
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              const Text(
                "Descrição",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
              Text(
                product.description!,
                style: TextStyle(fontSize: 16.0),
              )
            ],
          ),
        ),
      ],
    );
  }

  Stack _carouselSlider() {
    double metadeDaTela = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CarouselSlider(
          items: product.images!
              .map(
                (imagem) => SizedBox(
                  width: metadeDaTela,
                  // largura fixa para a imagem
                  height: metadeDaTela + (metadeDaTela / 3),
                  // altura fixa para a imagem (opcional)
                  child: Image.network(
                    imagem,
                    fit: BoxFit.cover,
                    height: 250.0,
                  ),
                ),
              )
              .toList(),
          carouselController: _controller,
          options: CarouselOptions(
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.95,
            aspectRatio: 0.99,
            autoPlayAnimationDuration: const Duration(milliseconds: 600),
            autoPlayInterval: const Duration(seconds: 3),
            initialPage: 2,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.transparent,
            child: Center(
              child: _indicadorCarousel(),
            ),
          ),
        ),
      ],
    );
  }

  Row _indicadorCarousel() {
    final Color primaryColor = Theme.of(context).primaryColor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: product.images!.asMap().entries.map((entry) {
        return GestureDetector(
          onTap: () => _controller.animateToPage(entry.key),
          child: Container(
            width: 12.0,
            height: 12.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : primaryColor)
                    .withOpacity(_current == entry.key ? 1.0 : 0.2)),
          ),
        );
      }).toList(),
    );
  }
}
