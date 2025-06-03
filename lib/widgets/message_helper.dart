import 'package:flutter/material.dart';

abstract class MessageHelper {

  static void showSnackBarMessage({
    required BuildContext context,
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

}