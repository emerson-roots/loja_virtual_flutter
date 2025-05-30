import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/datas/Produto.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/categoria.dart';
import 'package:loja_virtual/datas/cupom.dart';
import 'package:loja_virtual/datas/novidade.dart';
import 'package:loja_virtual/datas/order.dart';
import 'package:loja_virtual/datas/place.dart';
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
  Future<List<CartProduct>> loadCartItemsByUserId(String userId) async {
    QuerySnapshot<Map<String, dynamic>> carrinhos = await FirebaseFirestore
        .instance
        .collection("users")
        .doc(userId)
        .collection("cart")
        .get();

    List<CartProduct> result =
        carrinhos.docs.map((e) => CartProduct.fromDocument(e)).toList();

    result.forEach((cartProduct) async {
      if (cartProduct.productData == null) {
        DocumentSnapshot<Map<String, dynamic>> produto = await FirebaseFirestore
            .instance
            .collection("products")
            .doc(cartProduct.category)
            .collection("items")
            .doc(cartProduct.pid)
            .get();

        cartProduct.productData = Produto.fromDocument(produto);
      }
    });
    return result;
  }

  @override
  Future<Cupom> getCupomDesconto(String text) async {
    var result =
        await FirebaseFirestore.instance.collection("coupons").doc(text).get();

    Map<String, dynamic>? data = result.data();
    var cupom = data != null ? Cupom.fromJson(data) : Cupom.empty();

    return cupom;
  }

  @override
  Future<List<Place>> getPlaces() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection("places").get();
    List<Place> listObj = snapshot.docs.map((e) {
      var place = Place.fromJson(e.data());
      // seta o ID do firebase no objeto
      place.id = e.id;
      return place;
    }).toList();

    return listObj;
  }

  @override
  Future<List<OrderModel>> getPedidosByUserId(String userId) async {
    QuerySnapshot<Map<String, dynamic>> pedidosUsuario = await FirebaseFirestore
        .instance
        .collection("users")
        .doc(userId)
        .collection("orders")
        .get();

    var obj = await Future.wait(
      pedidosUsuario.docs.map((order) async {
        var resultSnapshot = await FirebaseFirestore.instance
            .collection("orders")
            .doc(order.id)
            .get();

        OrderModel orderMap = OrderModel.fromDocument(resultSnapshot);

        return orderMap;
      }).toList(),
    );

    return obj;
  }

  @override
  Future<String> postFinalizarPedido(
    List<CartProduct> products,
    String userId,
    double valorFrete,
    double valorTotalProdutos,
    double valorDesconto,
  ) async {
    // salva o pedido no firebase
    DocumentReference refOrderId =
        await FirebaseFirestore.instance.collection("orders").add({
      "clientId": userId,
      "products": products.map((cartProduct) => cartProduct.toMap()).toList(),
      "shipPrice": valorFrete,
      "productsPrice": valorTotalProdutos,
      "totalPrice": valorTotalProdutos - valorDesconto + valorFrete,
      "status": 1
    });

    // seta/associa o id do pedido para o usuario
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("orders")
        .doc(refOrderId.id)
        .set({"orderId": refOrderId.id});

    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("cart")
        .get();

    // remove produtos do carrinho
    for (var doc in query.docs) {
      doc.reference.delete();
    }

    var idPedido = refOrderId.id;
    return idPedido;
  }
}
