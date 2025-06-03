import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:loja_virtual/datas/constantes_globais.dart';
import 'package:loja_virtual/helpers/console_helper.dart';
import 'package:loja_virtual/interfaces/http_service.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/services/check_internet_service.dart';
import 'package:loja_virtual/widgets/message_helper.dart';

class DiscountCard extends StatefulWidget {
  const DiscountCard({Key? key}) : super(key: key);

  @override
  State<DiscountCard> createState() => _DiscountCardState();
}

class _DiscountCardState extends State<DiscountCard> {
  late bool isAbriuCarrinho = false;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isAbriuCarrinho) {
        MessageHelper.showSnackBarMessage(
            context: context,
            mensagem:
                'Utilize os cupons, 10OFF e 20OFF para simular o uso de cupons.\n\nCalculo de frente ainda não está implementado.',
            corSnackBar: Colors.deepOrange,
            tempoDuracaoMensagem: 5);

        isAbriuCarrinho = true;
      }
    });

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
                try {
                  if (!await CheckInternetService.hasInternetConnection()) {
                    MessageHelper.showSnackBarMessage(
                        context: context,
                        mensagem: 'Sem internet ou conexão limitada.',
                        corSnackBar: Colors.redAccent,
                        tempoDuracaoMensagem: 4);
                    return;
                  }

                  await GetIt.instance<IHttpService>(
                          instanceName: ConstantesGlobais.IHTTP_SERVICE_CONTEXT)
                      .getCupomDesconto(text)
                      .then((cupom) {
                    if (cupom != null && cupom.percent > 0) {
                      int porcentagemCadastrada = cupom.percent;
                      CartModel.of(context)
                          .setCoupon(text, porcentagemCadastrada);

                      MessageHelper.showSnackBarMessage(
                          context: context,
                          mensagem:
                              "Desconto de $porcentagemCadastrada% aplicado!",
                          corSnackBar: Colors.green,
                          tempoDuracaoMensagem: 4);
                    } else {
                      CartModel.of(context).setCoupon(null, 0);

                      MessageHelper.showSnackBarMessage(
                          context: context,
                          mensagem: "Cupom não existente!",
                          corSnackBar: Colors.redAccent,
                          tempoDuracaoMensagem: 4);
                    }
                  });
                } catch (ex, stack) {
                  ConsoleHelper.printError('Erro: $ex | Stack: $stack');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
