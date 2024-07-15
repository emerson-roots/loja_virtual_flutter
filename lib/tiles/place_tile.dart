import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  const PlaceTile(this.snapshot, {super.key});

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
              snapshot.get("image"),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  snapshot.get("title"),
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                  ),
                ),
                Text(
                  snapshot.get("address"),
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
                      "https://www.google.com/maps/search/?api=1&query=${snapshot.get("lat")},"
                      "${snapshot.get("long")}");

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
                  launchUrl(Uri.parse("tel:${snapshot.get("phone")}"));
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
