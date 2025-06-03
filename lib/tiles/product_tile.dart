import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/Produto.dart';
import 'package:loja_virtual/services/check_internet_service.dart';
import 'package:loja_virtual/widgets/message_helper.dart';
import '../screens/product_screen.dart';

class ProductTile extends StatelessWidget {
  final String type;
  final Produto product;

  ProductTile(this.type, this.product);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (!await CheckInternetService.hasInternetConnection()) {
          MessageHelper.showSnackBarMessage(
              context: context,
              mensagem: 'Sem internet ou conexão limitada.',
              corSnackBar: Colors.redAccent,
              tempoDuracaoMensagem: 4);
          return;
        }

        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ProductScreen(product)));
      },
      child: Card(
        child: type == "grid" ? _tabTipoColuna(context) : _tabTipoRow(context),
      ),
    );
  }

  Column _tabTipoColuna(BuildContext context) {
    double paddingAdaptavel = MediaQuery.of(context).size.width * 0.01;

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
            padding: EdgeInsets.all(paddingAdaptavel),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  product.title!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 5.0,
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
          ),
        ),
      ],
    );
  }

  Row _tabTipoRow(BuildContext context) {
    double paddingAdaptavel = MediaQuery.of(context).size.width * 0.01;
    double metadeDaTela = MediaQuery.of(context).size.width / 2;
    return Row(
      children: [
        SizedBox(
          width: metadeDaTela,
          // largura fixa para a imagem
          height: metadeDaTela + (metadeDaTela / 3),
          // altura fixa para a imagem (opcional)
          child: Image.network(
            product.images![0],
            fit: BoxFit.cover,
            height: 250.0,
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(paddingAdaptavel),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title!,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 5.0,
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
          ),
        ),
      ],
    );
  }
}
