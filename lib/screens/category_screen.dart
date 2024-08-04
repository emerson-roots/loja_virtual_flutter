import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:loja_virtual/datas/Produto.dart';
import 'package:loja_virtual/datas/categoria.dart';
import 'package:loja_virtual/interfaces/http_service.dart';
import 'package:provider/provider.dart';
import '../tiles/product_tile.dart';

class CategoryScreen extends StatelessWidget {
  final Categoria categoria;
  late IHttpService _httpService;

  CategoryScreen(this.categoria);

  int qtdTabs = 2;
  int maximoItensNaHorizontal = 2;

  @override
  Widget build(BuildContext context) {
    _httpService = GetIt.instance<IHttpService>();
    return DefaultTabController(
      length: qtdTabs,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            categoria.title,
            style: const TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  Icons.grid_on,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.list,
                ),
              )
            ],
          ),
        ),
        body: FutureBuilder<List<Produto>>(
          future: _httpService.getProdutosByCategoriaId(categoria.id),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              int qtdItensNaGrade = snapshot.data!.length;

              return TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  GridView.builder(
                    padding: const EdgeInsets.all(4.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: maximoItensNaHorizontal,
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: qtdItensNaGrade,
                    itemBuilder: (context, index) {
                      Produto data = snapshot.data![index];
                      data.category = this.categoria.id;
                      return ProductTile(
                        "grid",
                        data,
                      );
                    },
                  ),
                  ListView.builder(
                      padding: const EdgeInsets.all(4.0),
                      itemCount: qtdItensNaGrade,
                      itemBuilder: (context, index) {
                        Produto data = snapshot.data![index];
                        data.category = this.categoria.id;
                        return ProductTile(
                          "list",
                          data,
                        );
                      })
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
