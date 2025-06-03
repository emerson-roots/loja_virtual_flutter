import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get_it/get_it.dart';
import 'package:loja_virtual/datas/constantes_globais.dart';
import 'package:loja_virtual/datas/novidade.dart';
import 'package:loja_virtual/interfaces/http_service.dart';
import 'package:loja_virtual/services/check_internet_service.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late StreamSubscription<ConnectivityResult> _subscription;
  late IHttpService _httpService;
  late bool hasInternet = false;

  @override
  void initState() {
    _httpService = GetIt.instance<IHttpService>(
        instanceName: ConstantesGlobais.IHTTP_SERVICE_CONTEXT);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var temInternet = await CheckInternetService.hasInternetConnection();
      setState(() {
        hasInternet = temInternet;
      });
    });

    // Escuta mudanças de conectividade
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          hasInternet = false;
        });
      } else if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        setState(() {
          hasInternet = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                title: Text(
                  'Novidades',
                  style: TextStyle(color: Colors.white),
                ),
                centerTitle: true,
              ),
            ),
            hasInternet
                ? FutureBuilder<List<Novidade>>(
                    future: _httpService.getNovidades(),
                    builder: (context, AsyncSnapshot<List<Novidade>> snapshot) {
                      if (!snapshot.hasData) {
                        return SliverToBoxAdapter(
                          child: Container(
                            height: 200,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
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
                            (context, index) {
                              return FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: snapshot.data![index].image,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        );
                      }
                    },
                  )
                : SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.wifi_off, size: 90, color: Colors.white),
                            Text(
                              'Sem internet',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
          ],
        )
      ],
    );
  }
}
