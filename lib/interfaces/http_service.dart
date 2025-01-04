import 'package:loja_virtual/datas/Produto.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/categoria.dart';
import 'package:loja_virtual/datas/novidade.dart';

abstract class IHttpService {
  Future<List<Novidade>> getNovidades();
  Future<List<Categoria>> getAllCategorias();
  Future<List<Produto>> getProdutosByCategoriaId(String id);

  // cart model
  addCartItem(CartProduct cartProduct, String userId);
  removeCartItem(CartProduct cartProduct, String userId);
  decrementProduct(CartProduct cartProduct, String userId);
  incrementProduct(CartProduct cartProduct, String userId);
  Future<List<CartProduct>> loadCartItems(String userId);
}