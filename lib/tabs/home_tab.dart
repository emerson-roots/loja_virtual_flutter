import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_it/get_it.dart';
import 'package:loja_virtual/datas/novidade.dart';
import 'package:loja_virtual/interfaces/http_service.dart';
import 'package:loja_virtual/services/firebase_db_impl.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {
  late IHttpService _httpService;

  HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // injeção de dependencia com provider: ^6.0.0
    _httpService = GetIt.instance<IHttpService>();

    // renderiza o gradiente de cor de fundo
    Widget _buildBodyBack() => Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 211, 118, 130),
                Color.fromARGB(255, 253, 181, 168),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        );

    return Stack(
      children: <Widget>[
        _buildBodyBack(),
        CustomScrollView(
          slivers: [
            const SliverAppBar(
              iconTheme: IconThemeData(color: Colors.white),
              floating: true,
              snap: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Novidades', style: TextStyle(color: Colors.white),),
                centerTitle: true,
              ),
            ),
            FutureBuilder<List<Novidade>>(
              future: _httpService.getNovidades(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 200,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );
                } else {
                  return SliverGrid(
                    //gridDelegate controla o tamanho e a posição
                    gridDelegate: SliverQuiltedGridDelegate(
                      crossAxisCount: 3,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1,
                      repeatPattern: QuiltedGridRepeatPattern.inverted,
                      pattern: snapshot.data!.map((doc) {
                        return QuiltedGridTile(doc.x, doc.y);
                      }).toList(),
                    ),
                    delegate: SliverChildBuilderDelegate(
                      childCount: snapshot.data!.length,
                      (context, index) => FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: snapshot.data![index].image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }
              },
            )
          ],
        )
      ],
    );
  }
}
