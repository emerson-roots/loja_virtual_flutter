import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/interfaces/http_service.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;

  List<CartProduct> products = [];
  bool isLoading = false;

  String? couponCode;
  int discountPercentage = 0;

  late IHttpService _httpService;


  CartModel(this.user) {
    _httpService = GetIt.instance<IHttpService>();

    if (user.isLoggedIn()) {
      _loadCartItems();
    }
  }

  static CartModel of(BuildContext context) {
    return ScopedModel.of<CartModel>(context);
  }

  void addCartItem(CartProduct cartProduct) {
    _httpService.addCartItem(cartProduct, user.firebaseUser!.uid);
    products.add(cartProduct);
    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.uid)
        .collection("cart")
        .doc(cartProduct.cid)
        .delete();

    products.remove(cartProduct);

    notifyListeners();
  }

  void decrementProduct(CartProduct cartProduct) {
    cartProduct.quantity = cartProduct.quantity! - 1;

    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.uid)
        .collection("cart")
        .doc(cartProduct.cid)
        .update(cartProduct.toMap());

    notifyListeners();
  }

  void incrementProduct(CartProduct cartProduct) {
    cartProduct.quantity = cartProduct.quantity! + 1;

    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.uid)
        .collection("cart")
        .doc(cartProduct.cid)
        .update(cartProduct.toMap());

    notifyListeners();
  }

  void _loadCartItems() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.uid)
        .collection("cart")
        .get();

    products = query.docs.map((doc) => CartProduct.fromDocument(doc)).toList();

    notifyListeners();
  }

  void setCoupon(String? couponCode, int discountPercentage) {
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  double getProductsPrice() {
    double price = 0.0;

    for (CartProduct produto in products) {
      if (produto.productData != null) {
        price += produto.quantity! * produto.productData!.price!;
      }
    }

    return price;
  }

  double getShipPrice() {
    return 9.99;
  }

  double getDiscount() {
    return getProductsPrice() * discountPercentage / 100;
  }

  void updatePrices() {
    notifyListeners();
  }

  Future<String?> finishOrder() async {
    if (products.isEmpty) return null;

    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    // salva o pedido no firebase
    DocumentReference refOrderId =
        await FirebaseFirestore.instance.collection("orders").add({
      "clientId": user.firebaseUser!.uid,
      "products": products.map((cartProduct) => cartProduct.toMap()).toList(),
      "shipPrice": shipPrice,
      "productsPrice": productsPrice,
      "totalPrice": productsPrice - discount + shipPrice,
      "status": 1
    });

    // seta/associa o id do pedido para o usuario
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.uid)
        .collection("orders")
        .doc(refOrderId.id)
        .set({"orderId": refOrderId.id});

    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.uid)
        .collection("cart")
        .get();

    // remove produtos do carrinho
    for (var doc in query.docs) {
      doc.reference.delete();
    }

    // limpa o bound
    products.clear();

    couponCode = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();

    return refOrderId.id;
  }
}
