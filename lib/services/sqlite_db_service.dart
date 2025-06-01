import 'package:get_it/get_it.dart';
import 'package:loja_virtual/datas/Produto.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/categoria.dart';
import 'package:loja_virtual/datas/cupom.dart';
import 'package:loja_virtual/datas/novidade.dart';
import 'package:loja_virtual/datas/order.dart';
import 'package:loja_virtual/datas/place.dart';
import 'package:loja_virtual/datas/usuario.dart';
import 'package:loja_virtual/helpers/console_helper.dart';
import 'package:loja_virtual/helpers/exception_custom.dart';
import 'package:loja_virtual/interfaces/http_service.dart';
import 'package:loja_virtual/services/db_session_service.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteDbService implements IHttpService {
  late final DbSessionService _dbSession;

  SQLiteDbService() {
    _dbSession = GetIt.instance<DbSessionService>();
  }

  @override
  addCartItem(CartProduct cartProduct, String userId) {
    // TODO: implement addCartItem
    throw UnimplementedError();
  }

  @override
  Future<void> criarConta({required Usuario user}) async {
    Database? dbContact = await _dbSession.db;

    int? id = await dbContact?.insert('Users', user.toJson());
    user.id = id != null ? id.toString() : '0';
  }

  @override
  decrementProduct(CartProduct cartProduct, String userId) {
    // TODO: implement decrementProduct
    throw UnimplementedError();
  }

  @override
  Future<List<Categoria>> getAllCategorias() async {
    Database? dbContact = await _dbSession.db;

    List listMap = await dbContact!.rawQuery("SELECT * FROM Products");
    List<Categoria> listObj = listMap.map((e) => Categoria.fromMap(e)).toList();
    return listObj;
  }

  @override
  Future<Cupom> getCupomDesconto(String nomeCupom) {
    // TODO: implement getCupomDesconto
    throw UnimplementedError();
  }

  @override
  Future<List<Novidade>> getNovidades() async {
    Database? dbContact = await _dbSession.db;

    List listMap = await dbContact!.rawQuery("SELECT * FROM Home");
    List<Novidade> novidades = listMap.map((e) => Novidade.fromMap(e)).toList();
    return novidades;
  }

  @override
  Future<List<OrderModel>> getPedidosByUserId(String userId) {
    // TODO: implement getPedidosByUserId
    throw UnimplementedError();
  }

  @override
  Future<List<Place>> getPlaces() async {
    Database? dbContact = await _dbSession.db;

    List listMap = await dbContact!.rawQuery("SELECT * FROM Places");
    List<Place> listObj = listMap.map((e) => Place.fromJson(e)).toList();
    return listObj;
  }

  @override
  Future<List<Produto>> getProdutosByCategoriaId(String id) {
    // TODO: implement getProdutosByCategoriaId
    throw UnimplementedError();
  }

  @override
  incrementProduct(CartProduct cartProduct, String userId) {
    // TODO: implement incrementProduct
    throw UnimplementedError();
  }

  @override
  Future<List<CartProduct>> loadCartItemsByUserId(String userId) {
    // TODO: implement loadCartItemsByUserId
    throw UnimplementedError();
  }

  @override
  Future<Usuario> loadCurrentUser({required String userId}) async {
    Database? dbContact = await _dbSession.db;
    List<Map<String, Object?>> maps =
        await dbContact!.query('Users', where: "id = ?", whereArgs: [userId]);

    if (maps.isNotEmpty) {
      return Usuario.fromJson(maps.first);
    } else {
      throw Exception('Não foi possível carregar o usuário logado.');
    }
  }

  @override
  Future<void> logar({required Usuario user}) async {
    Database? dbContact = await _dbSession.db;
    List<Map<String, dynamic>> maps = await dbContact!.query('Users',
        where: "email = ? and password = ?",
        whereArgs: [user.email, user.password]);

    if (maps.isEmpty) {
      throw Exception('Usuário ou senha inválida.');
    } else {
      var obj = Usuario.fromJson(maps.first);
      user.id = obj.id;
    }
  }

  @override
  Future<String> postFinalizarPedido(List<CartProduct> products, String userId,
      double valorFrete, double valorTotalProdutos, double valorDesconto) {
    // TODO: implement postFinalizarPedido
    throw UnimplementedError();
  }

  @override
  Future<void> recoverPass({required String email}) async {
    ConsoleHelper.printAlert(
        '{recoverPass} em SQLiteDbService não possui ação!');
    throw ExceptionCustom(
        'Este app é somente de amostra/portifolio. Envio de e-mail para recuperação de senha está desativado.');
  }

  @override
  removeCartItem(CartProduct cartProduct, String userId) {
    // TODO: implement removeCartItem
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {
    ConsoleHelper.printAlert('{signOut} em SQLiteDbService não possui ação!');
  }
}
