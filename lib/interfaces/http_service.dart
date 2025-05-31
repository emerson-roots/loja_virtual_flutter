import 'dart:async';

import 'package:loja_virtual/datas/Produto.dart';
import 'package:loja_virtual/datas/usuario.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/categoria.dart';
import 'package:loja_virtual/datas/cupom.dart';
import 'package:loja_virtual/datas/novidade.dart';
import 'package:loja_virtual/datas/order.dart';
import 'package:loja_virtual/datas/place.dart';

abstract class IHttpService {
  Future<void> criarConta({required Usuario user});
  Future<void> logar({required Usuario user});
  Future<void> recoverPass({required String email});
  Future<void> signOut();
  Future<Usuario> loadCurrentUser({required String userId});

  Future<List<Novidade>> getNovidades();
  Future<List<Categoria>> getAllCategorias();
  Future<List<Produto>> getProdutosByCategoriaId(String id);

  // cart model
  addCartItem(CartProduct cartProduct, String userId);
  removeCartItem(CartProduct cartProduct, String userId);
  decrementProduct(CartProduct cartProduct, String userId);
  incrementProduct(CartProduct cartProduct, String userId);
  Future<List<CartProduct>> loadCartItemsByUserId(String userId);

  // Pedidos/Orders
  Future<List<OrderModel>> getPedidosByUserId(String userId);
  Future<Cupom> getCupomDesconto(String nomeCupom);
  Future<String> postFinalizarPedido(List<CartProduct> products, String userId, double valorFrete, double valorTotalProdutos, double valorDesconto);

  // lojas
  Future<List<Place>> getPlaces();

}