import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/place.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceTile extends StatelessWidget {
  // final DocumentSnapshot snapshot;
  final Place place;

  const PlaceTile(this.place, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 100.0,
            child: Image.network(
              place.image,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  place.title,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                  ),
                ),
                Text(
                  place.address,
                  textAlign: TextAlign.start,
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: const Text(
                  "Ver no Mapa",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Uri uri = Uri.parse(
                      "https://www.google.com/maps/search/?api=1&query=${place.lat},"
                      "${place.long}");

                  launchUrl(uri);
                },
              ),
              TextButton(
                child: const Text(
                  "Ligar",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  launchUrl(Uri.parse("tel:${place.phone}"));
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
