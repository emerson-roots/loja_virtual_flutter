import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/tiles/place_tile.dart';
import 'package:loja_virtual/widgets/custom_activity_indicator.dart';

class PlacesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection("places").get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CustomActivityIndicator();
        } else {
          return ListView(
            children: snapshot.data!.docs.map((doc) => PlaceTile(doc)).toList(),
          );
        }
      },
    );
  }
}
