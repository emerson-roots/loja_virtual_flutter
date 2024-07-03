import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
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
  final CarouselController _controller = CarouselController();

  _ProductScreenState(this.product);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
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
    return ListView(
      children: [
        _carouselSlider(),
        _tituloProdutoComPreco(),
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

  Padding _tituloProdutoComPreco() {
    final Color primaryColor = Theme.of(context).primaryColor;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            product.title!,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 3,
          ),
          Text(
            "R\$ ${product.price!.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          )
        ],
      ),
    );
  }
}
