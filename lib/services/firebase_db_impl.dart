import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/datas/novidade.dart';
import 'package:loja_virtual/interfaces/http_service.dart';

class FirebaseDbimpl extends IHttpService {
  @override
  Future<List<Novidade>> getNovidades() async {
    // Referência à coleção no Firestore
    Query<Map<String, dynamic>> novidadesRef =
    FirebaseFirestore.instance.collection('home').orderBy('pos');

    // Recupera os documentos da coleção
    QuerySnapshot querySnapshot = await novidadesRef.get();

    // Mapeia os documentos para objetos Novidade
    List<Novidade> novidades = querySnapshot.docs.map((doc) {
      return Novidade.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();

    return novidades;
  }
}
