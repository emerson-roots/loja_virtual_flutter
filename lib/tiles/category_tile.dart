import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/categoria.dart';
import 'package:loja_virtual/screens/category_screen.dart';
import 'package:loja_virtual/services/check_internet_service.dart';
import 'package:loja_virtual/widgets/message_helper.dart';

class CategoryTileCustom extends StatelessWidget {
  /*
  * properties */
  final Categoria categoria;

  CategoryTileCustom(this.categoria);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(categoria.icon),
      ),
      title: Text(
        categoria.title,
      ),
      trailing: const Icon(Icons.keyboard_arrow_right),
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
            MaterialPageRoute(builder: (context) => CategoryScreen(categoria)));
      },
    );
  }
}
