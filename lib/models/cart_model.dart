import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/helpers/console_helper.dart';
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
    _httpService.removeCartItem(cartProduct, user.firebaseUser!.uid);
    products.remove(cartProduct);
    notifyListeners();
  }

  void decrementProduct(CartProduct cartProduct) {
    cartProduct.quantity = cartProduct.quantity! - 1;
    _httpService.decrementProduct(cartProduct, user.firebaseUser!.uid);
    notifyListeners();
  }

  void incrementProduct(CartProduct cartProduct) {
    cartProduct.quantity = cartProduct.quantity! + 1;
    _httpService.incrementProduct(cartProduct, user.firebaseUser!.uid);
    notifyListeners();
  }

  void _loadCartItems() async {
    products = await _httpService.loadCartItemsByUserId(user.firebaseUser!.uid);
    notifyListeners();
  }

  void setCoupon(String? couponCode, int discountPercentage) {
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
    notifyListeners();
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
    ConsoleHelper.printAlert(
        '::: getShipPrice -> FRETE está com valor fixado de 9.99. Melhorar lógica depois...');
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

    // salva pedido no firebase
    var idPedido = await _httpService.postFinalizarPedido(
      products,
      user.firebaseUser!.uid,
      shipPrice,
      productsPrice,
      discount,
    );

    // limpa o bound
    products.clear();

    couponCode = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();

    return idPedido;
  }
}
