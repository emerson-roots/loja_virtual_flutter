import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:loja_virtual/datas/constantes_globais.dart';
import 'package:loja_virtual/datas/place.dart';
import 'package:loja_virtual/interfaces/http_service.dart';
import 'package:loja_virtual/tiles/place_tile.dart';
import 'package:loja_virtual/widgets/custom_activity_indicator.dart';

class PlacesTab extends StatelessWidget {
  const PlacesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Place>>(
      future: GetIt.instance<IHttpService>(instanceName: ConstantesGlobais.FIREBASE_INJECTION).getPlaces(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CustomActivityIndicator();
        } else {
          return ListView(
            children: snapshot.data!.map((place) => PlaceTile(place)).toList(),
          );
        }
      },
    );
  }
}
