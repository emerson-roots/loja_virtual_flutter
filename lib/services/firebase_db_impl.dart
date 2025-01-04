import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/datas/Produto.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/categoria.dart';
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

  @override
  Future<List<Categoria>> getAllCategorias() async {
    Query<Map<String, dynamic>> categoriasRef =
        FirebaseFirestore.instance.collection('products');

    QuerySnapshot querySnapshot = await categoriasRef.get();

    List<Categoria> categorias = querySnapshot.docs.map((doc) {
      return Categoria(
        doc.id,
        doc.get('title'),
        doc.get('icon'),
      );
    }).toList();

    return categorias;
  }

  @override
  Future<List<Produto>> getProdutosByCategoriaId(String id) async {
    try {
      Query<Map<String, dynamic>> refObj = FirebaseFirestore.instance
          .collection('products')
          .doc(id)
          .collection('items');

      QuerySnapshot querySnapshot = await refObj.get();

      List<Produto> list = querySnapshot.docs.map((doc) {
        return Produto.fromDocument(doc);
      }).toList();

      return list;
    } catch (e) {
      print('---------> Ocorreu um erro no getProdutosByCategoriaId: $e');
      throw e;
    }
  }

  @override
  addCartItem(CartProduct cartProduct, String userId) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("cart")
        .add(cartProduct.toMap())
        .then((docReferencia) {
      cartProduct.cid = docReferencia.id;
    });
  }

  @override
  removeCartItem(CartProduct cartProduct, String userId) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("cart")
        .doc(cartProduct.cid)
        .delete();
  }

  @override
  incrementProduct(CartProduct cartProduct, String userId) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("cart")
        .doc(cartProduct.cid)
        .update(cartProduct.toMap());
  }

  @override
  decrementProduct(CartProduct cartProduct, String userId) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("cart")
        .doc(cartProduct.cid)
        .update(cartProduct.toMap());
  }

  @override
  Future<List<CartProduct>> loadCartItems(String userId) async {

    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("cart")
        .get();

    return query.docs.map((doc) => CartProduct.fromDocument(doc)).toList();
  }
}
