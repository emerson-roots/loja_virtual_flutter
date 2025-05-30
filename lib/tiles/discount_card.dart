import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:loja_virtual/interfaces/http_service.dart';
import 'package:loja_virtual/models/cart_model.dart';

class DiscountCard extends StatelessWidget {
  const DiscountCard({super.key});

  @override
  Widget build(BuildContext context) {
    void _showSnackBarMessage({
      required String mensagem,
      required Color corSnackBar,
      required int tempoDuracaoMensagem,
    }) {
      var snackBar = SnackBar(
        content: Text(mensagem),
        backgroundColor: corSnackBar,
        duration: Duration(seconds: tempoDuracaoMensagem),
        action: SnackBarAction(
          label: 'FECHAR',
          textColor: Colors.white,
          onPressed: () {
            // Alguma ação opcional
          },
        ),
      );

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          "Cupom de Desconto",
          textAlign: TextAlign.start,
          style: TextStyle(
              fontWeight: FontWeight.w500, color: Colors.grey.shade700),
        ),
        leading: const Icon(Icons.card_giftcard),
        trailing: const Icon(Icons.add),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite seu cupom",
              ),
              initialValue: CartModel.of(context).couponCode ?? "",
              onFieldSubmitted: (text) async {
                await GetIt.instance<IHttpService>()
                    .getCupomDesconto(text)
                    .then((cupom) {
                  if (cupom != null && cupom.percent > 0) {
                    int porcentagemCadastrada = cupom.percent;
                    CartModel.of(context)
                        .setCoupon(text, porcentagemCadastrada);

                    _showSnackBarMessage(
                        mensagem:
                            "Desconto de $porcentagemCadastrada% aplicado!",
                        corSnackBar: Colors.green,
                        tempoDuracaoMensagem: 4);
                  } else {
                    CartModel.of(context).setCoupon(null, 0);

                    _showSnackBarMessage(
                        mensagem: "Cupom não existente!",
                        corSnackBar: Colors.redAccent,
                        tempoDuracaoMensagem: 4);
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
